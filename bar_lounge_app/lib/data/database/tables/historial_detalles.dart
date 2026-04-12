import 'package:drift/drift.dart';

/// Tabla: Detalles de línea del pedido
class HistorialDetalles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get detalleLocalUuid => text()();
  TextColumn get facturaLocalUuid => text()();
  IntColumn get productoId => integer()();
  TextColumn get productoNombre => text()();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
  RealColumn get montoImpuesto => real()();
  RealColumn get subtotalLinea => real()();
  TextColumn get estadoPreparacion => text().withDefault(const Constant('EN_COLA'))();
}
