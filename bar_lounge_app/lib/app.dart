import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/providers.dart';
import 'data/services/notification_service.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class NocturnalApp extends ConsumerStatefulWidget {
  const NocturnalApp({super.key});

  @override
  ConsumerState<NocturnalApp> createState() => _NocturnalAppState();
}

class _NocturnalAppState extends ConsumerState<NocturnalApp>
    with WidgetsBindingObserver {
  StreamSubscription<Uri>? _deepLinkSub;
  StreamSubscription<RemoteMessage>? _paymentMessageSub;
  StreamSubscription<String>? _tokenRefreshSub;
  Timer? _orderStatusTimer;
  bool _pollingOrderStatus = false;
  final Set<String> _handledPaymentFailures = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogSyncProvider).startPeriodicSync();
      ref.read(apiServiceProvider).syncFCMToken();
      _pollActiveOrderStatus();
      _orderStatusTimer = Timer.periodic(
        const Duration(seconds: 8),
        (_) => _pollActiveOrderStatus(),
      );
    });
    _requestPermissions();
    _setupPaymentListener();
    _initDeepLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkSub?.cancel();
    _paymentMessageSub?.cancel();
    _tokenRefreshSub?.cancel();
    _orderStatusTimer?.cancel();
    ref.read(catalogSyncProvider).stopPeriodicSync();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _pollActiveOrderStatus();
    }
  }

  void _initDeepLinks() async {
    final appLinks = AppLinks();

    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('[DeepLink] Could not get initial link: $e');
    }

    _deepLinkSub = appLinks.uriLinkStream.listen(
      (uri) => _handleDeepLink(uri),
      onError: (e) => debugPrint('[DeepLink] Stream error: $e'),
    );
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('[DeepLink] Received: $uri');
    final bool isCustomReset =
        uri.scheme == 'nocturnalbar' && uri.host == 'reset-password';
    final bool isHttpsReset =
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == 'nocturnal-bar.app' &&
        (uri.path == '/reset-password' || uri.path == '/confirm-reset');

    if (isCustomReset || isHttpsReset) {
      final token = uri.queryParameters['token'] ?? '';
      final encodedToken = Uri.encodeQueryComponent(token);
      debugPrint(
        '[DeepLink] Password reset token: ${token.substring(0, token.length.clamp(0, 8))}...',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.go('/confirm-reset?token=$encodedToken');
      });
    }
  }

  void _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      '[FCM] User granted permission: ${settings.authorizationStatus}',
    );
  }

  void _setupPaymentListener() {
    try {
      _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen((
        String _,
      ) {
        ref.read(apiServiceProvider).syncFCMToken();
      });

      _paymentMessageSub = FirebaseMessaging.onMessage.listen((
        RemoteMessage message,
      ) async {
        await _handleIncomingPaymentMessage(message, showSyncToast: true);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM ON_MESSAGE_OPEN_APP] User tapped notification');
        _handleIncomingPaymentMessage(message);
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          debugPrint('[FCM INITIAL_MESSAGE] Opened from terminated state');
          _handleIncomingPaymentMessage(message);
        }
      });
    } catch (e) {
      debugPrint('[FCM] Listener setup failed: $e');
    }
  }

  Future<void> _handleIncomingPaymentMessage(
    RemoteMessage message, {
    bool showSyncToast = false,
  }) async {
    debugPrint('[FCM MESSAGE] Received message data: ${message.data}');
    final String? action = message.data['action'];
    final String? facturaUuid = message.data['factura_uuid'];
    if (facturaUuid == null || facturaUuid.isEmpty) {
      debugPrint('[FCM] No factura_uuid in message, ignoring.');
      return;
    }

    try {
      if (showSyncToast) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(seconds: 1),
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.45),
                ),
                boxShadow: AppColors.navBarShadow,
              ),
              child: Text(
                'Syncing payment...',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }

      final session = await ref.read(sesionDaoProvider).getActiveSession();
      final orderInDb = await ref
          .read(historialDaoProvider)
          .getOrderByUuid(facturaUuid);

      if (action == 'ORDER_PAYMENT_FAILED') {
        await _handlePaymentFailure(facturaUuid);
        return;
      }

      final int? clienteId = session?.clienteId ?? orderInDb?.clienteId;
      final int numeroMesa = orderInDb?.numeroMesa ?? 0;
      if (clienteId == null) {
        debugPrint('[FCM] No local customer found for order $facturaUuid.');
        return;
      }

      final sum = await ref.read(apiServiceProvider).getResumenCuenta(facturaUuid);

      final bool isPaymentSuccess =
          action == 'ORDER_PAID' ||
          sum.estado_cuenta == 'CERRADA' ||
          sum.estado_cuenta == 'CERRADO' ||
          sum.estado_cuenta == 'PAGADA' ||
          sum.estado_cuenta == 'PAGADO' ||
          sum.estado_cuenta == 'COMPLETADA' ||
          sum.estado_cuenta == 'COMPLETADO';
      final bool isPaymentFailed =
          action == 'ORDER_PAYMENT_FAILED' ||
          sum.estado_cuenta == 'CANCELADO' ||
          sum.estado_cuenta == 'CANCELLED';

      final String finalEstado =
          isPaymentSuccess
              ? 'PAGADA'
              : isPaymentFailed
              ? 'CANCELADO'
              : sum.estado_cuenta;

      await ref.read(historialDaoProvider).syncExistingOrder(
            clienteId: clienteId,
            numeroMesa: numeroMesa,
            facturaUuid: facturaUuid,
            subtotal: sum.subtotal_acumulado,
            totalImpuestos: sum.total_impuestos_acumulado,
            propinaLegal: sum.propina_legal_acumulada,
            totalGeneral: sum.total_general_acumulado,
            estadoCuenta: finalEstado,
            items: sum.items_consumidos,
            propinaVoluntaria: orderInDb?.propinaVoluntaria ?? 0.0,
          );
      debugPrint(
        '[FCM] Order $facturaUuid local database updated to state: $finalEstado',
      );

      if (isPaymentFailed) {
        await _handlePaymentFailure(facturaUuid);
        return;
      }

      if (isPaymentSuccess) {
        ref.read(cancellationProvider.notifier).stopTimer();
        await NotificationService.showNotification(
          id: facturaUuid.hashCode,
          title: 'Payment confirmed',
          body: 'Your Nocturnal order has been paid. Thank you for visiting.',
        );

        final activeHistory = await ref
            .read(historialDaoProvider)
            .watchOrders(clienteId: clienteId)
            .first;
        for (final o in activeHistory) {
          if (o.estadoCuenta != 'CERRADA' &&
              o.estadoCuenta != 'PAGADA' &&
              o.estadoCuenta != 'CERRADO' &&
              o.estadoCuenta != 'PAGADO' &&
              o.estadoCuenta != 'COMPLETADA' &&
              o.estadoCuenta != 'COMPLETADO') {
            await ref
                .read(historialDaoProvider)
                .updateOrderStatus(o.facturaLocalUuid, 'PAGADA');
          }
        }

        await ref.read(mesaDaoProvider).clearAllActiveMesas();
        await ref.read(carritoDaoProvider).clearCart();
        ref.read(sessionProvider.notifier).clearSession();

        try {
          if (mounted) {
            appRouter.go('/scanner');
          }
        } catch (e) {
          debugPrint('[FCM Error] Navigation to /scanner failed: $e');
        }

        Future.delayed(const Duration(milliseconds: 500), () {
          final rootContext = appRouter.routerDelegate.navigatorKey.currentContext;
          if (rootContext != null) {
            _showSuccessDialog(rootContext);
          } else {
            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text('Thank you for your payment.'),
              ),
            );
          }
        });
      }
    } catch (e) {
      debugPrint('[FCM Error] Failed to process message: $e');
    }
  }

  Future<void> _pollActiveOrderStatus() async {
    if (_pollingOrderStatus || !mounted) return;
    _pollingOrderStatus = true;
    try {
      final activeOrder = await ref.read(activeOrderProvider.future);
      if (activeOrder == null) return;
      final summary = await ref
          .read(apiServiceProvider)
          .getResumenCuenta(activeOrder.facturaLocalUuid);
      final state = summary.estado_cuenta.toUpperCase();
      if (state == 'CANCELADO' || state == 'CANCELLED') {
        await _handlePaymentFailure(activeOrder.facturaLocalUuid);
      }
    } catch (e) {
      debugPrint('[ORDER POLL] Status check skipped: $e');
    } finally {
      _pollingOrderStatus = false;
    }
  }

  Future<void> _handlePaymentFailure(String facturaUuid) async {
    if (!_handledPaymentFailures.add(facturaUuid)) return;
    try {
      final existingOrder = await ref
          .read(historialDaoProvider)
          .getOrderByUuid(facturaUuid);
      if (existingOrder != null) {
        await ref
            .read(historialDaoProvider)
            .updateOrderStatus(facturaUuid, 'CANCELADO');
      }
      ref.read(cancellationProvider.notifier).stopTimer();
      await NotificationService.showNotification(
        id: facturaUuid.hashCode,
        title: 'Payment unsuccessful',
        body:
            'The bar could not accept this payment. Please contact your server.',
      );
      await ref.read(mesaDaoProvider).clearAllActiveMesas();
      await ref.read(carritoDaoProvider).clearCart();
      ref.read(sessionProvider.notifier).clearSession();
      if (mounted) {
        appRouter.go('/scanner');
      }
      scaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Payment failed. The bar rejected this table order. Please contact your server.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 6),
          ),
        );
    } catch (e) {
      _handledPaymentFailures.remove(facturaUuid);
      debugPrint('[PAYMENT FAILURE] Could not update local state: $e');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222D),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PAYMENT SUCCESSFUL',
                    style: GoogleFonts.epilogue(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Thank you for ordering!',
                    style: GoogleFonts.epilogue(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We hope you enjoyed your time at Nocturnal. Looking forward to your next visit!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'GO BACK TO SCANNER',
                        style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF181B25),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp.router(
      title: 'NOCTURNAL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
