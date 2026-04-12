import 'package:drift/drift.dart';

/// Tabla: Historial de pedidos (facturas)
class HistorialPedidos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get facturaLocalUuid => text()();
  IntColumn get clienteId => integer().nullable()(); // Owner of this order
  IntColumn get numeroMesa => integer()();
  RealColumn get subtotal => real()();
  RealColumn get totalImpuestos => real()();
  RealColumn get propinaLegal => real()();
  RealColumn get totalGeneral => real()();
  RealColumn get propinaVoluntaria => real().withDefault(const Constant(0.0))();
  TextColumn get estadoCuenta => text().withDefault(const Constant('ABIERTA'))();
  TextColumn get comentariosCocina => text().nullable()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}
