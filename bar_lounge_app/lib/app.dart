import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/providers/providers.dart';
import 'data/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class NocturnalApp extends ConsumerStatefulWidget {
  const NocturnalApp({super.key});
  @override
  ConsumerState<NocturnalApp> createState() => _NocturnalAppState();
}

class _NocturnalAppState extends ConsumerState<NocturnalApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogSyncProvider).startPeriodicSync();
    });
    _requestPermissions();
    _setupPaymentListener();
  }

  @override
  void dispose() {
    ref.read(catalogSyncProvider).stopPeriodicSync();
    super.dispose();
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
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        debugPrint('[FCM ON_MESSAGE] Received message data: ${message.data}');
        final String? action = message.data['action'];
        final String? uuidRecibido = message.data['factura_uuid'];
        if (uuidRecibido == null || uuidRecibido.isEmpty) {
          debugPrint('[FCM] No factura_uuid in message, ignoring.');
          return;
        }
        try {
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('Sincronizando pago...'),
              duration: Duration(seconds: 1),
            ),
          );
          final session = await ref.read(sesionDaoProvider).getActiveSession();
          final orderInDb = await ref
              .read(historialDaoProvider)
              .getOrderByUuid(uuidRecibido);
          int? clienteId = session?.clienteId ?? orderInDb?.clienteId;
          int numeroMesa = orderInDb?.numeroMesa ?? 0;
          if (clienteId != null) {
            final sum = await ref
                .read(apiServiceProvider)
                .getResumenCuenta(uuidRecibido);

            final bool isPaymentSuccess =
                action == 'ORDER_PAID' ||
                sum.estado_cuenta == 'CERRADA' ||
                sum.estado_cuenta == 'CERRADO' ||
                sum.estado_cuenta == 'PAGADA' ||
                sum.estado_cuenta == 'PAGADO' ||
                sum.estado_cuenta == 'COMPLETADA' ||
                sum.estado_cuenta == 'COMPLETADO';

            final finalEstado = isPaymentSuccess ? 'PAGADA' : sum.estado_cuenta;

            await ref
                .read(historialDaoProvider)
                .syncExistingOrder(
                  clienteId: clienteId,
                  numeroMesa: numeroMesa,
                  facturaUuid: uuidRecibido,
                  subtotal: sum.subtotal_acumulado,
                  totalImpuestos: sum.total_impuestos_acumulado,
                  propinaLegal: sum.propina_legal_acumulada,
                  totalGeneral: sum.total_general_acumulado,
                  estadoCuenta: finalEstado,
                  items: sum.items_consumidos,
                  propinaVoluntaria: orderInDb?.propinaVoluntaria ?? 0.0,
                );
            debugPrint(
              '[FCM] Order $uuidRecibido local database updated to state: $finalEstado',
            );
            if (isPaymentSuccess) {
              await NotificationService.showNotification(
                id: uuidRecibido.hashCode,
                title: 'Payment confirmed',
                body:
                    'Your Nocturnal order has been paid. Thank you for visiting.',
              );
              debugPrint(
                '[FCM] Payment success detected for UUID: $uuidRecibido. Cleaning up all user ghost sessions.',
              );

              final activeHistory =
                  await ref
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
                  debugPrint(
                    '[FCM Warning] Ghost order found and closed safely: ${o.facturaLocalUuid}',
                  );
                }
              }

              await ref.read(mesaDaoProvider).clearAllActiveMesas();
              await ref.read(carritoDaoProvider).clearCart();
              debugPrint(
                '[FCM] Cleared all active tables and cart after payment success.',
              );
              debugPrint('[FCM] Triggering UI reset and Success Popup...');
              try {
                if (mounted) {
                  appRouter.go('/scanner');
                }
              } catch (e) {
                debugPrint('[FCM Error] Navigation to /scanner failed: $e');
              }
              Future.delayed(const Duration(milliseconds: 500), () {
                final rootContext =
                    appRouter.routerDelegate.navigatorKey.currentContext;
                if (rootContext != null) {
                  debugPrint(
                    '[FCM] Executing _showSuccessDialog on Root Context',
                  );
                  _showSuccessDialog(rootContext);
                } else {
                  debugPrint(
                    '[FCM Error] Global context for dialog not found. Is appRouter initialized?',
                  );
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(
                      content: Text(
                        '¡Gracias por tu pago! (Error al mostrar diálogo)',
                      ),
                    ),
                  );
                }
              });
            }
          }
        } catch (e) {
          debugPrint('[FCM Error] Failed to process message: $e');
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM ON_MESSAGE_OPEN_APP] User tapped notification');
      });
    } catch (_) {}
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
