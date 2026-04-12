// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historial_dao.dart';

// ignore_for_file: type=lint
mixin _$HistorialDaoMixin on DatabaseAccessor<AppDatabase> {
  $HistorialPedidosTable get historialPedidos =>
      attachedDatabase.historialPedidos;
  $HistorialDetallesTable get historialDetalles =>
      attachedDatabase.historialDetalles;
  HistorialDaoManager get managers => HistorialDaoManager(this);
}

class HistorialDaoManager {
  final _$HistorialDaoMixin _db;
  HistorialDaoManager(this._db);
  $$HistorialPedidosTableTableManager get historialPedidos =>
      $$HistorialPedidosTableTableManager(
        _db.attachedDatabase,
        _db.historialPedidos,
      );
  $$HistorialDetallesTableTableManager get historialDetalles =>
      $$HistorialDetallesTableTableManager(
        _db.attachedDatabase,
        _db.historialDetalles,
      );
}
