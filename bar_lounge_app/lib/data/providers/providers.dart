import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../api/api_client.dart';
import '../api/services/api_service.dart';
import '../services/catalog_sync_service.dart';
import '../services/promotions_eval_service.dart';
export 'cancellation_provider.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  ref.onDispose(() => db.close());
  return db;
});

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final apiServiceProvider = Provider<ApiService>(
    (ref) => ApiService(ref.watch(apiClientProvider)));

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

final promocionesDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).promocionesDao);

final promotionsEvalServiceProvider = Provider<PromotionsEvalService>((ref) {
  return PromotionsEvalService(ref.watch(promocionesDaoProvider));
});

final catalogSyncProvider = Provider<CatalogSyncService>((ref) {

  return CatalogSyncService(
    ref.watch(apiServiceProvider),
    ref.watch(catalogoDaoProvider),
    ref.watch(promocionesDaoProvider),
  );
});

final activePromotionsProvider = StreamProvider(
    (ref) => ref.watch(promocionesDaoProvider).watchActivePromotions());

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
      if (order.estadoCuenta != 'CERRADA' && 
          order.estadoCuenta != 'CERRADO' &&
          order.estadoCuenta != 'PAGADA' &&
          order.estadoCuenta != 'PAGADO' &&
          order.estadoCuenta != 'COMPLETADA' &&
          order.estadoCuenta != 'COMPLETADO') {
        return order;
      }
    }
    return null;
  });
});

final orderDetailsProvider = StreamProvider.family<List<HistorialDetalle>, String>(
    (ref, facturaUuid) => ref.watch(historialDaoProvider).watchOrderDetails(facturaUuid));
final allOrderDetailsProvider = StreamProvider<List<HistorialDetalle>>((ref) {
  final session = ref.watch(activeSessionProvider).maybeWhen(
    data: (s) => s,
    orElse: () => null,
  );
  return ref.watch(historialDaoProvider).watchAllOrderDetails(clienteId: session?.clienteId);
});

// ---------------------------------------------------------------------------
// BEST-PROMO PER-PRODUCT — Resolves all promo types (TODOS + PRODUCTOS + CATEGORIAS)
// ---------------------------------------------------------------------------

/// Unique key that identifies a product by both its id and its category.
class ProductPromoKey {
  final int productId;
  final int categoriaId;
  const ProductPromoKey(this.productId, this.categoriaId);

  @override
  bool operator ==(Object other) =>
      other is ProductPromoKey &&
      other.productId == productId &&
      other.categoriaId == categoriaId;

  @override
  int get hashCode => Object.hash(productId, categoriaId);
}

/// Async provider that resolves the best promotion for a single product,
/// including PRODUCTOS and CATEGORIAS scoped promos (requires DB queries).
final productBestPromoProvider =
    FutureProvider.family<PromocionesCacheData?, ProductPromoKey>((ref, key) {
  return ref
      .watch(promotionsEvalServiceProvider)
      .getBestPromotion(key.productId, key.categoriaId);
});

final categoryBestPromoProvider =
    FutureProvider.family<PromocionesCacheData?, int>((ref, categoriaId) {
  return ref
      .watch(promotionsEvalServiceProvider)
      .getBestPromoForCategory(categoriaId);
});

// ---------------------------------------------------------------------------
// SESSION PROVIDER — Stores the active QR scan result (sucursalId + mesaId)
// ---------------------------------------------------------------------------

/// Immutable state for the active QR session.
class SessionState {
  final int sucursalId;
  final int mesaId;

  const SessionState({required this.sucursalId, required this.mesaId});

  /// Returns a copy with updated fields.
  SessionState copyWith({int? sucursalId, int? mesaId}) => SessionState(
        sucursalId: sucursalId ?? this.sucursalId,
        mesaId: mesaId ?? this.mesaId,
      );

  @override
  String toString() => 'SessionState(sucursalId: $sucursalId, mesaId: $mesaId)';
}

/// [SessionNotifier] manages the current table/branch binding obtained via QR.
class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState(sucursalId: 0, mesaId: 0);

  /// Updates both IDs after a successful QR scan.
  void setSession({required int sucursalId, required int mesaId}) {
    state = state.copyWith(sucursalId: sucursalId, mesaId: mesaId);
  }

  /// Resets the session (e.g. after payment or logout).
  void clearSession() {
    state = const SessionState(sucursalId: 0, mesaId: 0);
  }
}

/// Global provider — use [ref.read(sessionProvider.notifier).setSession(...)]
/// from the QR scanner after a successful scan.
final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

