import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../api/api_client.dart';
import '../api/services/api_service.dart';
import '../services/catalog_sync_service.dart';

// ── Core Infrastructure ───────────────────────────────────────

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final apiServiceProvider = Provider<ApiService>(
    (ref) => ApiService(ref.watch(apiClientProvider)));

// ── DAOs ─────────────────────────────────────────────────────

final sesionDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).sesionDao);

final catalogoDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).catalogoDao);

final mesaDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).mesaDao);

final carritoDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).carritoDao);

final historialDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).historialDao);

// ── Services ─────────────────────────────────────────────────

/// Catalog sync service — call .syncCatalog() on app start
final catalogSyncProvider = Provider<CatalogSyncService>((ref) {
  return CatalogSyncService(
    ref.watch(apiServiceProvider),
    ref.watch(catalogoDaoProvider),
  );
});

// ── Reactive Streams ─────────────────────────────────────────

final activeSessionProvider = StreamProvider(
    (ref) => ref.watch(sesionDaoProvider).watchActiveSession());

final activeMesaProvider = StreamProvider(
    (ref) => ref.watch(mesaDaoProvider).watchActiveMesa());

final categoriasProvider = StreamProvider(
    (ref) => ref.watch(catalogoDaoProvider).watchAllCategorias());

final allProductosProvider = StreamProvider(
    (ref) => ref.watch(catalogoDaoProvider).watchAllProductos());

final productosByCategoriaProvider =
    StreamProvider.family<List<ProductosCacheData>, int>(
        (ref, categoriaId) => ref
            .watch(catalogoDaoProvider)
            .watchProductosByCategoria(categoriaId));

final cartItemsProvider = StreamProvider(
    (ref) => ref.watch(carritoDaoProvider).watchCartItems());

final cartItemCountProvider = StreamProvider<int>(
    (ref) => ref.watch(carritoDaoProvider).watchCartItemCount());

final ordersProvider = StreamProvider((ref) {
  final session = ref.watch(activeSessionProvider).maybeWhen(
    data: (s) => s,
    orElse: () => null,
  );
  return ref.watch(historialDaoProvider).watchOrders(clienteId: session?.clienteId);
});

final activeOrderProvider = StreamProvider<HistorialPedido?>((ref) {
  final session = ref.watch(activeSessionProvider).maybeWhen(
    data: (s) => s,
    orElse: () => null,
  );
  return ref.watch(historialDaoProvider).watchOrders(clienteId: session?.clienteId).map((orders) {
    for (final order in orders) {
      if (order.estadoCuenta != 'CERRADA' && order.estadoCuenta != 'CERRADO') {
        return order;
      }
    }
    return null;
  });
});

final orderDetailsProvider = StreamProvider.family<List<HistorialDetalle>, String>(
    (ref, facturaUuid) => ref.watch(historialDaoProvider).watchOrderDetails(facturaUuid));

/// Streams all order line details for the currently logged-in client
final allOrderDetailsProvider = StreamProvider<List<HistorialDetalle>>((ref) {
  final session = ref.watch(activeSessionProvider).maybeWhen(
    data: (s) => s,
    orElse: () => null,
  );
  return ref.watch(historialDaoProvider).watchAllOrderDetails(clienteId: session?.clienteId);
});

// ── Reservations DAO ──
final reservationsDaoProvider = Provider((ref) => ref.watch(databaseProvider).reservationsDao);

final userReservationsProvider = StreamProvider((ref) {
  final session = ref.watch(activeSessionProvider).maybeWhen(
    data: (s) => s,
    orElse: () => null,
  );
  if (session?.clienteId == null) return Stream.value(<TableReservation>[]);
  return ref.watch(reservationsDaoProvider).watchReservationsForClient(session!.clienteId!);
});
