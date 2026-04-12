import 'package:drift/drift.dart';
import 'sesion_cliente.dart';

class TableReservations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId => integer().references(SesionCliente, #clienteId)();
  TextColumn get venueName => text()();
  DateTimeColumn get resDate => dateTime()();
  TextColumn get resTime => text()();
  TextColumn get guestsCount => text()();
  TextColumn get specialRequests => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('Upcoming'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
