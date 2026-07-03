import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../api/services/api_service.dart';
import '../api/dto/api_models.dart';
import '../database/daos/catalogo_dao.dart';
import '../database/app_database.dart';
import '../mappers/api_to_drift_mapper.dart';
import '../database/daos/promociones_dao.dart';

List<CategoriaDto> _parseCategorias(List<dynamic> data) {
  return data.map((e) => CategoriaDto.fromJson(e as Map<String, dynamic>)).toList();
}

List<ProductoDto> _parseProductos(List<dynamic> data) {
  return data.map((e) => ProductoDto.fromJson(e as Map<String, dynamic>)).toList();
}

List<PromocionDto> _parsePromociones(List<dynamic> data) {
  return data.map((e) => PromocionDto.fromJson(e as Map<String, dynamic>)).toList();
}

class CatalogSyncService {
  final ApiService _api;
  final CatalogoDao _catalogoDao;
  final PromocionesDao _promocionesDao;
  int? _lastSyncUnix;
  Timer? _syncTimer;
  bool _isSyncing = false;

  CatalogSyncService(this._api, this._catalogoDao, this._promocionesDao);

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

      final rawPromos = await _api.getPromocionesActivas();
      final promociones = await compute(_parsePromociones, rawPromos);
      final promosCompanions = ApiToDriftMapper.promocionesToCompanions(promociones);
      
      final prodRels = <PromocionesProductosCacheCompanion>[];
      final catRels = <PromocionesCategoriasCacheCompanion>[];
      for (final p in promociones) {
        prodRels.addAll(ApiToDriftMapper.promocionProductosToCompanions(p));
        catRels.addAll(ApiToDriftMapper.promocionCategoriasToCompanions(p));
      }
      
      // We always replace promotions to ensure accurate evaluation
      await _promocionesDao.replaceAllPromotions(promosCompanions, prodRels, catRels);

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
      
      // Only update timestamp if everything succeeded
      _lastSyncUnix = currentUnix;
      
    } on DioException catch (dioErr) {
      debugPrint('[SYNC] Catalog API sync skipped (offline) - DioException: ${dioErr.message}');

    } catch (e) {
      debugPrint('[SYNC] Catalog sync threw unexpected error: $e');

    } finally {
      _isSyncing = false;
    }
  }
}
