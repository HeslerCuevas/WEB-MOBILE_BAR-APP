// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sesion_dao.dart';

// ignore_for_file: type=lint
mixin _$SesionDaoMixin on DatabaseAccessor<AppDatabase> {
  $SesionClienteTable get sesionCliente => attachedDatabase.sesionCliente;
  SesionDaoManager get managers => SesionDaoManager(this);
}

class SesionDaoManager {
  final _$SesionDaoMixin _db;
  SesionDaoManager(this._db);
  $$SesionClienteTableTableManager get sesionCliente =>
      $$SesionClienteTableTableManager(_db.attachedDatabase, _db.sesionCliente);
}
