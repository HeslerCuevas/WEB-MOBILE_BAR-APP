import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../tables/carrito_local.dart';
part 'carrito_dao.g.dart';
const _uuid = Uuid();
@DriftAccessor(tables: [CarritoLocal])
class CarritoDao extends DatabaseAccessor<AppDatabase> with _$CarritoDaoMixin {
  CarritoDao(super.db);
  Future<void> addItem({
    required int productoId,
    required String nombreProducto,
    required double precioUnitario,
    required double tasaImpuesto,
    String? comentarios,
  }) async {
    final existing = await (select(carritoLocal)
          ..where((c) => c.productoId.equals(productoId)))
        .getSingleOrNull();
    if (existing != null) {
      final newQty = existing.cantidad + 1;
      final subtotal = _roundTo2(precioUnitario * newQty);
      final impuesto = _roundTo2(subtotal * tasaImpuesto);
      await (update(carritoLocal)..where((c) => c.id.equals(existing.id)))
          .write(CarritoLocalCompanion(
        cantidad: Value(newQty),
        subtotalLinea: Value(subtotal),
        montoImpuesto: Value(impuesto),
      ));
    } else {
      final subtotal = _roundTo2(precioUnitario * 1);
      final impuesto = _roundTo2(subtotal * tasaImpuesto);
      await into(carritoLocal).insert(CarritoLocalCompanion.insert(
        detalleLocalUuid: _uuid.v4(),
        productoId: productoId,
        nombreProducto: nombreProducto,
        precioUnitario: precioUnitario,
        tasaImpuesto: Value(tasaImpuesto),
        subtotalLinea: subtotal,
        montoImpuesto: impuesto,
        comentariosCocina: Value(comentarios),
      ));
    }
  }
  Future<void> updateQuantity(int id, int newQty) async {
    if (newQty <= 0) {
      await (delete(carritoLocal)..where((c) => c.id.equals(id))).go();
      return;
    }
    final item = await (select(carritoLocal)..where((c) => c.id.equals(id)))
        .getSingle();
    final subtotal = _roundTo2(item.precioUnitario * newQty);
    final impuesto = _roundTo2(subtotal * item.tasaImpuesto);
    await (update(carritoLocal)..where((c) => c.id.equals(id))).write(
      CarritoLocalCompanion(
        cantidad: Value(newQty),
        subtotalLinea: Value(subtotal),
        montoImpuesto: Value(impuesto),
      ),
    );
  }
  Future<void> removeItem(int id) =>
      (delete(carritoLocal)..where((c) => c.id.equals(id))).go();
  Stream<List<CarritoLocalData>> watchCartItems() =>
      select(carritoLocal).watch();
  Future<List<CarritoLocalData>> getCartItems() =>
      select(carritoLocal).get();
  Stream<int> watchCartItemCount() {
    final countExpr = carritoLocal.cantidad.sum();
    final query = selectOnly(carritoLocal)..addColumns([countExpr]);
    return query.map((row) => row.read(countExpr) ?? 0).watchSingle();
  }
  Future<CartTotals> calculateTotals() async {
    final items = await getCartItems();
    double subtotalGeneral = 0;
    double totalImpuestos = 0;
    for (final item in items) {
      subtotalGeneral += item.subtotalLinea;
      totalImpuestos += item.montoImpuesto;
    }
    subtotalGeneral = _roundTo2(subtotalGeneral);
    totalImpuestos = _roundTo2(totalImpuestos);
    final propinaLegal = _roundTo2(subtotalGeneral * 0.10);
    final totalGeneral = _roundTo2(subtotalGeneral + totalImpuestos + propinaLegal);
    return CartTotals(
      subtotal: subtotalGeneral,
      totalImpuestos: totalImpuestos,
      propinaLegal: propinaLegal,
      totalGeneral: totalGeneral,
    );
  }
  Future<int> clearCart() => delete(carritoLocal).go();
  static double _roundTo2(double value) =>
      double.parse(value.toStringAsFixed(2));
}
class CartTotals {
  final double subtotal;
  final double totalImpuestos;
  final double propinaLegal;
  final double totalGeneral;
  const CartTotals({
    required this.subtotal,
    required this.totalImpuestos,
    required this.propinaLegal,
    required this.totalGeneral,
  });
}
