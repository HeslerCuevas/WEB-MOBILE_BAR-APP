import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categorias_cache.dart';
import '../tables/productos_cache.dart';

part 'catalogo_dao.g.dart';

@DriftAccessor(tables: [CategoriasCache, ProductosCache])
class CatalogoDao extends DatabaseAccessor<AppDatabase>
    with _$CatalogoDaoMixin {
  CatalogoDao(super.db);

  // ── Categories ──────────────────────────────────────────
  Future<List<CategoriasCacheData>> getAllCategorias() =>
      select(categoriasCache).get();

  Stream<List<CategoriasCacheData>> watchAllCategorias() =>
      select(categoriasCache).watch();

  Future<void> insertCategorias(List<CategoriasCacheCompanion> entries) async {
    await delete(categoriasCache).go();
    await batch((b) => b.insertAll(categoriasCache, entries));
  }

  // ── Products ────────────────────────────────────────────
  Future<List<ProductosCacheData>> getProductosByCategoria(int categoriaId) {
    return (select(productosCache)
          ..where((p) => p.categoriaId.equals(categoriaId)))
        .get();
  }

  Stream<List<ProductosCacheData>> watchProductosByCategoria(int categoriaId) {
    return (select(productosCache)
          ..where((p) => p.categoriaId.equals(categoriaId)))
        .watch();
  }

  Stream<List<ProductosCacheData>> watchAllProductos() =>
      select(productosCache).watch();

  Future<void> insertProductos(List<ProductosCacheCompanion> entries) async {
    await delete(productosCache).go();
    await batch((b) => b.insertAll(productosCache, entries));
  }

  Future<ProductosCacheData?> getProductoById(int id) {
    return (select(productosCache)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  /// Upsert categories from API — replaces all cache
  Future<void> upsertCategorias(
      List<CategoriasCacheCompanion> entries) async {
    await batch((b) => b.insertAllOnConflictUpdate(categoriasCache, entries));
  }
  
  /// Wipe out all cached catalog elements before full sync to avoid lingering dummy elements
  Future<void> clearAllCatalog() async {
    await delete(productosCache).go();
    await delete(categoriasCache).go();
  }

  /// Upsert products for a given category from API natively in a single transaction
  Future<void> upsertProductos(
      List<ProductosCacheCompanion> entries, int categoriaId) async {
    await transaction(() async {
      // Remove old products for that category
      await (delete(productosCache)
            ..where((p) => p.categoriaId.equals(categoriaId)))
          .go();
          
      // Insert new products natively
      if (entries.isNotEmpty) {
        await batch((b) => b.insertAll(productosCache, entries));
      }
    });
  }

  /// Atomically wipe and replace the entire catalog in one single database transaction
  Future<void> replaceFullCatalog(
    List<CategoriasCacheCompanion> cats,
    List<ProductosCacheCompanion> prods,
  ) async {
    await transaction(() async {
      await clearAllCatalog();
      if (cats.isNotEmpty) {
        await batch((b) => b.insertAll(categoriasCache, cats));
      }
      if (prods.isNotEmpty) {
        await batch((b) => b.insertAll(productosCache, prods));
      }
    });
  }
}
