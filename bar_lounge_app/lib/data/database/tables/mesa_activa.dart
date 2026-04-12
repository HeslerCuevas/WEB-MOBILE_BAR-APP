import 'package:drift/drift.dart';

/// Tabla: Mesa activa vinculada por QR o entrada manual
class MesaActiva extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get numeroMesa => integer()();
  TextColumn get codigoQrMesa => text().nullable()();
  TextColumn get estadoCuenta => text().withDefault(const Constant('ABIERTA'))();
  TextColumn get facturaLocalUuid => text().nullable()();
  DateTimeColumn get vinculadoEn => dateTime().withDefault(currentDateAndTime)();
}
