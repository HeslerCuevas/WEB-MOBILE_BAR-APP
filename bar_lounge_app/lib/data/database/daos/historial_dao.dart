import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/historial_pedidos.dart';
import '../tables/historial_detalles.dart';

part 'historial_dao.g.dart';

@DriftAccessor(tables: [HistorialPedidos, HistorialDetalles])
class HistorialDao extends DatabaseAccessor<AppDatabase>
    with _$HistorialDaoMixin {
  HistorialDao(super.db);

  Future<void> createOrder(HistorialPedidosCompanion order,
      List<HistorialDetallesCompanion> details) async {
    await into(historialPedidos).insert(order);
    await batch((b) => b.insertAll(historialDetalles, details));
  }

  /// Watch orders belonging to a specific client only
  Stream<List<HistorialPedido>> watchOrders({int? clienteId}) {
    return (select(historialPedidos)
          ..where((o) => clienteId != null
              ? o.clienteId.equals(clienteId)
              : o.clienteId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.creadoEn)]))
        .watch();
  }

  Future<HistorialPedido?> getOrderByUuid(String uuid) {
    return (select(historialPedidos)
          ..where((o) => o.facturaLocalUuid.equals(uuid)))
        .getSingleOrNull();
  }

  Stream<List<HistorialDetalle>> watchOrderDetails(String facturaUuid) {
    return (select(historialDetalles)
          ..where((d) => d.facturaLocalUuid.equals(facturaUuid)))
        .watch();
  }

  /// Stream all details for orders belonging to a specific client
  Stream<List<HistorialDetalle>> watchAllOrderDetails({int? clienteId}) {
    if (clienteId == null) {
      return Stream.value([]);
    }
    // Join via subquery: get all uuids belonging to this client
    final ordersQuery = select(historialPedidos)
      ..where((o) => o.clienteId.equals(clienteId));

    return ordersQuery.watch().asyncExpand((orders) {
      if (orders.isEmpty) return Stream.value([]);
      final uuids = orders.map((o) => o.facturaLocalUuid).toList();
      return (select(historialDetalles)
            ..where((d) => d.facturaLocalUuid.isIn(uuids)))
          .watch();
    });
  }

  Future<void> updateOrderTotals({
    required String facturaUuid,
    required double newSubtotal,
    required double newTotalImpuestos,
    required double newTotalGeneral,
  }) {
    return (update(historialPedidos)
          ..where((o) => o.facturaLocalUuid.equals(facturaUuid)))
        .write(HistorialPedidosCompanion(
      subtotal: Value(newSubtotal),
      totalImpuestos: Value(newTotalImpuestos),
      totalGeneral: Value(newTotalGeneral),
    ));
  }

  Future<void> appendOrderDetails(
      String facturaUuid, List<HistorialDetallesCompanion> details) async {
    if (details.isEmpty) return;
    await batch((b) => b.insertAll(historialDetalles, details));
  }

  Future<void> updateOrderStatus(String facturaUuid, String newStatus, {double? propinaVoluntaria}) {
    return (update(historialPedidos)
          ..where((o) => o.facturaLocalUuid.equals(facturaUuid)))
        .write(HistorialPedidosCompanion(
      estadoCuenta: Value(newStatus),
      propinaVoluntaria: propinaVoluntaria == null ? const Value.absent() : Value(propinaVoluntaria),
    ));
  }

  Future<void> updateItemStatus(String detalleUuid, String newStatus) {
    return (update(historialDetalles)
          ..where((d) => d.detalleLocalUuid.equals(detalleUuid)))
        .write(HistorialDetallesCompanion(
      estadoPreparacion: Value(newStatus),
    ));
  }

  /// Delete all orders and their details for a given client (called on logout)
  Future<void> clearOrdersForClient(int clienteId) async {
    final orders = await (select(historialPedidos)
          ..where((o) => o.clienteId.equals(clienteId)))
        .get();
    final uuids = orders.map((o) => o.facturaLocalUuid).toList();
    if (uuids.isNotEmpty) {
      await (delete(historialDetalles)
            ..where((d) => d.facturaLocalUuid.isIn(uuids)))
          .go();
    }
    await (delete(historialPedidos)
          ..where((o) => o.clienteId.equals(clienteId)))
        .go();
  }
}
