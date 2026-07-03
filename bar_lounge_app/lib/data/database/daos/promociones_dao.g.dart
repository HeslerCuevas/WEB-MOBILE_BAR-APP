// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promociones_dao.dart';

// ignore_for_file: type=lint
mixin _$PromocionesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PromocionesCacheTable get promocionesCache =>
      attachedDatabase.promocionesCache;
  $PromocionesProductosCacheTable get promocionesProductosCache =>
      attachedDatabase.promocionesProductosCache;
  $PromocionesCategoriasCacheTable get promocionesCategoriasCache =>
      attachedDatabase.promocionesCategoriasCache;
  PromocionesDaoManager get managers => PromocionesDaoManager(this);
}

class PromocionesDaoManager {
  final _$PromocionesDaoMixin _db;
  PromocionesDaoManager(this._db);
  $$PromocionesCacheTableTableManager get promocionesCache =>
      $$PromocionesCacheTableTableManager(
        _db.attachedDatabase,
        _db.promocionesCache,
      );
  $$PromocionesProductosCacheTableTableManager get promocionesProductosCache =>
      $$PromocionesProductosCacheTableTableManager(
        _db.attachedDatabase,
        _db.promocionesProductosCache,
      );
  $$PromocionesCategoriasCacheTableTableManager
  get promocionesCategoriasCache =>
      $$PromocionesCategoriasCacheTableTableManager(
        _db.attachedDatabase,
        _db.promocionesCategoriasCache,
      );
}
