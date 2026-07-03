import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/promociones_cache.dart';

part 'promociones_dao.g.dart';

@DriftAccessor(tables: [PromocionesCache, PromocionesProductosCache, PromocionesCategoriasCache])
class PromocionesDao extends DatabaseAccessor<AppDatabase> with _$PromocionesDaoMixin {
  PromocionesDao(super.db);

  Future<void> replaceAllPromotions(
      List<PromocionesCacheCompanion> promos,
      List<PromocionesProductosCacheCompanion> prodRels,
      List<PromocionesCategoriasCacheCompanion> catRels) async {
    await transaction(() async {
      await delete(promocionesCache).go();
      await delete(promocionesProductosCache).go();
      await delete(promocionesCategoriasCache).go();

      await batch((batch) {
        batch.insertAll(promocionesCache, promos);
        batch.insertAll(promocionesProductosCache, prodRels);
        batch.insertAll(promocionesCategoriasCache, catRels);
      });
    });
  }

  Future<List<PromocionesCacheData>> getActivePromotions() {
    return (select(promocionesCache)..where((t) => t.activo.equals(true))).get();
  }

  Stream<List<PromocionesCacheData>> watchActivePromotions() {
    return (select(promocionesCache)..where((t) => t.activo.equals(true))).watch();
  }

  Future<List<int>> getProductosForPromo(int promoId) async {
    final rels = await (select(promocionesProductosCache)..where((t) => t.promocionId.equals(promoId))).get();
    return rels.map((e) => e.productoId).toList();
  }

  Future<List<int>> getCategoriasForPromo(int promoId) async {
    final rels = await (select(promocionesCategoriasCache)..where((t) => t.promocionId.equals(promoId))).get();
    return rels.map((e) => e.categoriaId).toList();
  }
}
