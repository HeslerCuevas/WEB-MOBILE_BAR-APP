import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../api/services/api_service.dart';
import '../api/dto/api_models.dart';
import '../database/daos/catalogo_dao.dart';
import '../database/app_database.dart';
import '../mappers/api_to_drift_mapper.dart';

// ── Top-Level isolate workers for compute() ──
List<CategoriaDto> _parseCategorias(List<dynamic> data) {
  return data.map((e) => CategoriaDto.fromJson(e as Map<String, dynamic>)).toList();
}

List<ProductoDto> _parseProductos(List<dynamic> data) {
  return data.map((e) => ProductoDto.fromJson(e as Map<String, dynamic>)).toList();
}

/// Syncs API catalog data into the local Drift cache using multithreading for JSON mapping.
/// Called on app launch - works offline if API is unreachable.
class CatalogSyncService {
  final ApiService _api;
  final CatalogoDao _catalogoDao;

  CatalogSyncService(this._api, this._catalogoDao);

  Future<void> syncCatalog({int? lastSyncTimestamp}) async {
    try {
      // 1. Fetch raw API categories with timestamp query
      final rawCats = await _api.getCategorias(lastSyncTimestamp: lastSyncTimestamp);
      
      // 2. Parse payload in separate isolate using compute
      final categorias = await compute(_parseCategorias, rawCats);
      final catCompanions = ApiToDriftMapper.categoriasToCompanions(categorias);

      // If full sync, hold everything back and atomically write it once
      if (lastSyncTimestamp == null) {
        final allProducts = <ProductosCacheCompanion>[];
        for (final cat in categorias) {
          try {
            final rawProducts = await _api.getProductos(cat.id, lastSyncTimestamp: lastSyncTimestamp);
            final productos = await compute(_parseProductos, rawProducts);
            allProducts.addAll(ApiToDriftMapper.productosToCompanions(productos, cat.id));
          } on DioException catch (dioErr) {
            debugPrint('[SYNC] Products for category ${cat.id} failed network operation: ${dioErr.message}');
          } catch (e) {
            debugPrint('[SYNC] Products for category ${cat.id} failed parse: $e');
          }
        }
        await _catalogoDao.replaceFullCatalog(catCompanions, allProducts);
        debugPrint('[SYNC] Catalog synced: ${categorias.length} categories instantly replaced.');
      } else {
        // Incremental: Upsert categories, then upsert products per category sequentially
        await _catalogoDao.upsertCategorias(catCompanions);
        for (final cat in categorias) {
          try {
            final rawProducts = await _api.getProductos(cat.id, lastSyncTimestamp: lastSyncTimestamp);
            final productos = await compute(_parseProductos, rawProducts);
            final prodCompanions = ApiToDriftMapper.productosToCompanions(productos, cat.id);
            await _catalogoDao.upsertProductos(prodCompanions, cat.id);
          } on DioException catch (dioErr) {
            debugPrint('[SYNC] Products for category ${cat.id} failed network operation: ${dioErr.message}');
          } catch (e) {
            debugPrint('[SYNC] Products for category ${cat.id} failed parse/db operation: $e');
          }
        }
        debugPrint('[SYNC] Catalog synced: ${categorias.length} categories incrementally updating.');
      }
    } on DioException catch (dioErr) {
      // Gracefully capture Network/Timeout Exceptions & permit the app to boot via local Drift cache
      debugPrint('[SYNC] Catalog API sync skipped (offline) - DioException: ${dioErr.message}');
    } catch (e) {
      debugPrint('[SYNC] Catalog sync threw unexpected error: $e');
    }
  }
}
