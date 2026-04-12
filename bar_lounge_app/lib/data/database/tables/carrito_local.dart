import 'package:drift/drift.dart';
import 'productos_cache.dart';

/// Tabla: Carrito local de pre-pedido
class CarritoLocal extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get detalleLocalUuid => text()();
  IntColumn get productoId => integer().references(ProductosCache, #id)();
  TextColumn get nombreProducto => text()();
  IntColumn get cantidad => integer().withDefault(const Constant(1))();
  RealColumn get precioUnitario => real()();
  RealColumn get tasaImpuesto => real().withDefault(const Constant(0.18))();
  RealColumn get subtotalLinea => real()();
  RealColumn get montoImpuesto => real()();
  TextColumn get comentariosCocina => text().nullable()();
  DateTimeColumn get agregadoEn => dateTime().withDefault(currentDateAndTime)();
}
