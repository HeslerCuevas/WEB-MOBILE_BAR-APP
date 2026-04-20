import 'package:drift/drift.dart';
class HistorialPedidos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get facturaLocalUuid => text()();
  IntColumn get clienteId => integer().nullable()(); 
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
