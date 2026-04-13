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
        if (message.data['action'] == 'ORDER_PAID') {
          final String? uuidRecibido = message.data['factura_uuid'];
          if (uuidRecibido == null) return;

          final mesaData = await ref.read(mesaDaoProvider).getActiveMesa();
          
          if (mesaData != null && mesaData.facturaLocalUuid == uuidRecibido) {
            
            // 1. Force the database to refresh the account from the backend API
            final session = await ref.read(sesionDaoProvider).getActiveSession();
            if (session?.clienteId != null) {
               try {
                  final sum = await ref.read(apiServiceProvider).getResumenCuenta(uuidRecibido);
                  await ref.read(historialDaoProvider).syncExistingOrder(
                    clienteId: session!.clienteId!,
                    numeroMesa: mesaData.numeroMesa,
                    facturaUuid: uuidRecibido,
                    subtotal: sum.subtotal_acumulado,
                    totalImpuestos: sum.total_impuestos_acumulado,
                    propinaLegal: sum.propina_legal_acumulada,
                    totalGeneral: sum.total_general_acumulado,
                    estadoCuenta: sum.estado_cuenta,
                    items: sum.items_consumidos,
                  );
               } catch (e) {
                  debugPrint('Failed to sync finalized order: $e');
               }
            }

            // 2. Clear out the locally active open table so they can scan into a brand new one
            await ref.read(mesaDaoProvider).clearAllActiveMesas();

            // 3. Show global success popup securely
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '¡Pago Confirmado! Tu cuenta ha sido pagada. ¡Gracias por visitarnos!',
                        style: const TextStyle(fontWeight: FontWeight.w600),
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

            // 4. Force UX reset back to Scanner scanner state 
            try {
              appRouter.go('/scanner');
            } catch (_) {}
          }
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
