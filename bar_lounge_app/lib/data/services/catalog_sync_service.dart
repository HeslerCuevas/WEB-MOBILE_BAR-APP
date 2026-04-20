import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../api/services/api_service.dart';
import '../api/dto/api_models.dart';
import '../database/daos/catalogo_dao.dart';
import '../database/app_database.dart';
import '../mappers/api_to_drift_mapper.dart';
List<CategoriaDto> _parseCategorias(List<dynamic> data) {
  return data.map((e) => CategoriaDto.fromJson(e as Map<String, dynamic>)).toList();
}
List<ProductoDto> _parseProductos(List<dynamic> data) {
  return data.map((e) => ProductoDto.fromJson(e as Map<String, dynamic>)).toList();
}
class CatalogSyncService {
  final ApiService _api;
  final CatalogoDao _catalogoDao;
  int? _lastSyncUnix;
  Timer? _syncTimer;
  bool _isSyncing = false;

  CatalogSyncService(this._api, this._catalogoDao);

  void startPeriodicSync() {
    syncCatalog();
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      syncCatalog();
    });
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
  }

  Future<void> syncCatalog({int? lastSyncTimestamp}) async {
    if (_isSyncing) return;
    _isSyncing = true;
    final int? effectiveTimestamp = lastSyncTimestamp ?? _lastSyncUnix;
    final int currentUnix = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      final rawCats = await _api.getCategorias(lastSyncTimestamp: effectiveTimestamp);
      final categorias = await compute(_parseCategorias, rawCats);
      final catCompanions = ApiToDriftMapper.categoriasToCompanions(categorias);
      if (effectiveTimestamp == null) {
        final allProducts = <ProductosCacheCompanion>[];
        for (final cat in categorias) {
          try {
            final rawProducts = await _api.getProductos(cat.id, lastSyncTimestamp: effectiveTimestamp);
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
        if (catCompanions.isNotEmpty) {
          await _catalogoDao.upsertCategorias(catCompanions);
        }
        for (final cat in categorias) {
          try {
            final rawProducts = await _api.getProductos(cat.id, lastSyncTimestamp: effectiveTimestamp);
            final productos = await compute(_parseProductos, rawProducts);
            final prodCompanions = ApiToDriftMapper.productosToCompanions(productos, cat.id);
            if (prodCompanions.isNotEmpty) {
              await _catalogoDao.upsertProductos(prodCompanions);
            }
          } on DioException catch (dioErr) {
            debugPrint('[SYNC] Products for category ${cat.id} failed network operation: ${dioErr.message}');
          } catch (e) {
            debugPrint('[SYNC] Products for category ${cat.id} failed parse/db operation: $e');
          }
        }
        debugPrint('[SYNC] Catalog synced: ${categorias.length} categories incrementally updating.');
      }
    } on DioException catch (dioErr) {
      debugPrint('[SYNC] Catalog API sync skipped (offline) - DioException: ${dioErr.message}');
    } catch (e) {
      debugPrint('[SYNC] Catalog sync threw unexpected error: $e');
    } finally {
      // If categories were fetched successfully (no dio errors handled earlier), we update our timestamp.
      // Even if network fails gracefully, we only update if the sync block completely exits without throwing,
      // but to be safe we update it if we didn't throw an unhandled error inside.
      _lastSyncUnix = currentUnix;
      _isSyncing = false;
    }
  }
}
