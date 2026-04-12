// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrito_dao.dart';

// ignore_for_file: type=lint
mixin _$CarritoDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasCacheTable get categoriasCache => attachedDatabase.categoriasCache;
  $ProductosCacheTable get productosCache => attachedDatabase.productosCache;
  $CarritoLocalTable get carritoLocal => attachedDatabase.carritoLocal;
  CarritoDaoManager get managers => CarritoDaoManager(this);
}

class CarritoDaoManager {
  final _$CarritoDaoMixin _db;
  CarritoDaoManager(this._db);
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
  $$CarritoLocalTableTableManager get carritoLocal =>
      $$CarritoLocalTableTableManager(_db.attachedDatabase, _db.carritoLocal);
}
