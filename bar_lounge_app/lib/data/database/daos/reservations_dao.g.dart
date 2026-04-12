// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_dao.dart';

// ignore_for_file: type=lint
mixin _$ReservationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SesionClienteTable get sesionCliente => attachedDatabase.sesionCliente;
  $TableReservationsTable get tableReservations =>
      attachedDatabase.tableReservations;
  ReservationsDaoManager get managers => ReservationsDaoManager(this);
}

class ReservationsDaoManager {
  final _$ReservationsDaoMixin _db;
  ReservationsDaoManager(this._db);
  $$SesionClienteTableTableManager get sesionCliente =>
      $$SesionClienteTableTableManager(_db.attachedDatabase, _db.sesionCliente);
  $$TableReservationsTableTableManager get tableReservations =>
      $$TableReservationsTableTableManager(
        _db.attachedDatabase,
        _db.tableReservations,
      );
}
