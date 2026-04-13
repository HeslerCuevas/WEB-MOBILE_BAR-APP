import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class NocturnalApp extends ConsumerStatefulWidget {
  const NocturnalApp({super.key});

  @override
  ConsumerState<NocturnalApp> createState() => _NocturnalAppState();
}

class _NocturnalAppState extends ConsumerState<NocturnalApp> {
  @override
  void initState() {
    super.initState();
    // Sync catalog from API on app launch (non-blocking, offline-safe)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogSyncProvider).syncCatalog();
    });

    _setupPaymentListener();
  }

  void _setupPaymentListener() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        debugPrint('[FCM ON_MESSAGE] Received message data: ${message.data}');
        
        // Accept ORDER_PAID or dynamically any update containing factura_uuid
        final String? action = message.data['action'];
        final String? uuidRecibido = message.data['factura_uuid'];
        
        if (uuidRecibido == null || uuidRecibido.isEmpty) {
          debugPrint('[FCM] No factura_uuid in message, ignoring.');
          return;
        }

        try {
          final session = await ref.read(sesionDaoProvider).getActiveSession();
          final orderInDb = await ref.read(historialDaoProvider).getOrderByUuid(uuidRecibido);
          int? clienteId = session?.clienteId ?? orderInDb?.clienteId;
          int numeroMesa = orderInDb?.numeroMesa ?? 0;

          if (clienteId != null) {
            // 1. Force the database to refresh the account from the backend API regardless of current state
            final sum = await ref.read(apiServiceProvider).getResumenCuenta(uuidRecibido);
            
            await ref.read(historialDaoProvider).syncExistingOrder(
              clienteId: clienteId,
              numeroMesa: numeroMesa,
              facturaUuid: uuidRecibido,
              subtotal: sum.subtotal_acumulado,
              totalImpuestos: sum.total_impuestos_acumulado,
              propinaLegal: sum.propina_legal_acumulada,
              totalGeneral: sum.total_general_acumulado,
              estadoCuenta: sum.estado_cuenta,
              items: sum.items_consumidos,
            );
            debugPrint('[FCM] Order $uuidRecibido local database updated to state: ${sum.estado_cuenta}');

            // If it's a payment confirmation, do the visual updates and reset the table
            if (action == 'ORDER_PAID' || sum.estado_cuenta == 'CERRADA' || sum.estado_cuenta == 'CERRADO') {
              final mesaData = await ref.read(mesaDaoProvider).getActiveMesa();
              if (mesaData != null && mesaData.facturaLocalUuid == uuidRecibido) {
                // Clear out the locally active open table
                await ref.read(mesaDaoProvider).clearAllActiveMesas();

                // Show global success popup securely
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            '¡Pago Confirmado! Tu cuenta ha sido pagada. ¡Gracias por visitarnos!',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 4),
                  ),
                );

                // Force UX reset back to Scanner
                try {
                  appRouter.go('/scanner');
                } catch (_) {}
              }
            }
          }
        } catch (e) {
          debugPrint('[FCM Error] Failed to process message: $e');
        }
      });
    } catch (_) {
       // Firebase isn't correctly configured yet, swallow gracefully.
    }
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
