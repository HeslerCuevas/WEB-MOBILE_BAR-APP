import 'package:drift/drift.dart';

class SesionCliente extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionToken => text().nullable()();
  TextColumn get nombreDisplay => text().withDefault(const Constant('Guest'))();
  TextColumn get email => text().nullable()();
  BoolColumn get emailVerificado => boolean().withDefault(const Constant(false))();
  IntColumn get clienteId => integer().nullable()();
  BoolColumn get esInvitado => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiraEn => dateTime().nullable()();
}
