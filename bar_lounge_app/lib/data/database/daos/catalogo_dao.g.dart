// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogo_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogoDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasCacheTable get categoriasCache => attachedDatabase.categoriasCache;
  $ProductosCacheTable get productosCache => attachedDatabase.productosCache;
  CatalogoDaoManager get managers => CatalogoDaoManager(this);
}

class CatalogoDaoManager {
  final _$CatalogoDaoMixin _db;
  CatalogoDaoManager(this._db);
  $$CategoriasCacheTableTableManager get categoriasCache =>
      $$CategoriasCacheTableTableManager(
        _db.attachedDatabase,
        _db.categoriasCache,
      );
  $$ProductosCacheTableTableManager get productosCache =>
      $$ProductosCacheTableTableManager(
        _db.attachedDatabase,
        _db.productosCache,
      );
}
