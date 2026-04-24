import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/historial_pedidos.dart';
import '../tables/historial_detalles.dart';
import '../tables/productos_cache.dart';
import '../../api/dto/api_models.dart';
part 'historial_dao.g.dart';
@DriftAccessor(tables: [HistorialPedidos, HistorialDetalles, ProductosCache])
class HistorialDao extends DatabaseAccessor<AppDatabase>
    with _$HistorialDaoMixin {
  HistorialDao(super.db);
  Future<void> createOrder(HistorialPedidosCompanion order,
      List<HistorialDetallesCompanion> details) async {
    await into(historialPedidos).insert(order);
    await batch((b) => b.insertAll(historialDetalles, details));
  }
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
  Stream<List<HistorialDetalle>> watchAllOrderDetails({int? clienteId}) {
    if (clienteId == null) {
      return Stream.value([]);
    }
    final query = select(historialDetalles).join([
      innerJoin(
        historialPedidos,
        historialDetalles.facturaLocalUuid.equalsExp(historialPedidos.facturaLocalUuid),
      ),
    ])..where(historialPedidos.clienteId.equals(clienteId));

    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(historialDetalles)).toList();
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
  Future<void> clearAllHistory() async {
    await delete(historialDetalles).go();
    await delete(historialPedidos).go();
  }
  Future<void> syncExistingOrder({
    required int clienteId,
    required int numeroMesa,
    required String facturaUuid,
    required double subtotal,
    required double totalImpuestos,
    required double propinaLegal,
    required double totalGeneral,
    required String estadoCuenta,
    required List<ItemResumen> items,
    double propinaVoluntaria = 0.0,
  }) async {
    await (delete(historialPedidos)..where((o) => o.facturaLocalUuid.equals(facturaUuid))).go();
    await (delete(historialDetalles)..where((d) => d.facturaLocalUuid.equals(facturaUuid))).go();
    await into(historialPedidos).insert(
      HistorialPedidosCompanion.insert(
        facturaLocalUuid: facturaUuid,
        clienteId: Value(clienteId),
        numeroMesa: numeroMesa,
        subtotal: subtotal,
        totalImpuestos: totalImpuestos,
        propinaLegal: propinaLegal,
        totalGeneral: totalGeneral,
        estadoCuenta: Value(estadoCuenta),
        propinaVoluntaria: Value(propinaVoluntaria),
      ),
    );
    final catalogProducts = await select(productosCache).get();
    final details = items.map((ItemResumen i) {
      final subL = i.subtotal_linea;
      final qty = i.cantidad;
      final pU = qty > 0 ? (subL / qty) : 0.0;
      final mI = subL * 0.18; 
      String finalName = i.producto_nombre;
      if (finalName.toLowerCase().startsWith('producto ')) {
        final possibleId = int.tryParse(finalName.split(' ').last);
        if (possibleId != null) {
          final match = catalogProducts.where((p) => p.id == possibleId).firstOrNull;
          if (match != null) {
            finalName = match.nombre;
          }
        }
      }
      return HistorialDetallesCompanion.insert(
        detalleLocalUuid: 'resumed-${DateTime.now().millisecondsSinceEpoch}-${i.producto_nombre.hashCode}',
        facturaLocalUuid: facturaUuid,
        productoId: 0, 
        productoNombre: finalName,
        cantidad: qty,
        precioUnitario: pU,
        montoImpuesto: mI,
        subtotalLinea: subL,
        estadoPreparacion: Value(i.estado_preparacion),
      );
    }).toList();
    if (details.isNotEmpty) {
      await batch((b) => b.insertAll(historialDetalles, details));
    }
  }
}
