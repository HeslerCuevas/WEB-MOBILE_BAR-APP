// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesa_dao.dart';

// ignore_for_file: type=lint
mixin _$MesaDaoMixin on DatabaseAccessor<AppDatabase> {
  $MesaActivaTable get mesaActiva => attachedDatabase.mesaActiva;
  MesaDaoManager get managers => MesaDaoManager(this);
}

class MesaDaoManager {
  final _$MesaDaoMixin _db;
  MesaDaoManager(this._db);
  $$MesaActivaTableTableManager get mesaActiva =>
      $$MesaActivaTableTableManager(_db.attachedDatabase, _db.mesaActiva);
}
