import 'package:flutter/foundation.dart';
import '../../core/utils/timezone.dart';
import '../database/daos/promociones_dao.dart';
import '../database/app_database.dart';

class PromotionsEvalService {
  final PromocionesDao _dao;

  PromotionsEvalService(this._dao);

  // ── Core promo selection ────────────────────────────────────────────────

  Future<PromocionesCacheData?> getBestPromotion(int productoId, int categoriaId) async {
    final activePromos = await _dao.getActivePromotions();
    final now = TimezoneUtil.getLocalNow();
    
    PromocionesCacheData? bestPromo;

    for (final promo in activePromos) {
      if (!isPromotionTimeEligible(promo, now)) continue;
      
      if (promo.aplicaA == 'PRODUCTOS') {
        final allowedProdIds = await _dao.getProductosForPromo(promo.id);
        if (!allowedProdIds.contains(productoId)) continue;
      } else if (promo.aplicaA == 'CATEGORIA' || promo.aplicaA == 'CATEGORIAS') {
        final allowedCatIds = await _dao.getCategoriasForPromo(promo.id);
        if (!allowedCatIds.contains(categoriaId)) continue;
      }
      // 'TODOS' — applies to everything, no extra filter needed

      if (bestPromo == null) {
        bestPromo = promo;
        continue;
      }

      if (promo.prioridad > bestPromo.prioridad) {
        bestPromo = promo;
      } else if (promo.prioridad == bestPromo.prioridad) {
        if (promo.valor > bestPromo.valor) {
          bestPromo = promo;
        }
      }
    }
    
    return bestPromo;
  }

  /// Returns the best active promotion that applies to an entire category
  /// (i.e., aplicaA == 'CATEGORIAS' and categoriaId is in its list, or 'TODOS').
  Future<PromocionesCacheData?> getBestPromoForCategory(int categoriaId) async {
    final activePromos = await _dao.getActivePromotions();
    final now = TimezoneUtil.getLocalNow();
    PromocionesCacheData? best;

    for (final promo in activePromos) {
      if (!isPromotionTimeEligible(promo, now)) continue;
      if (promo.aplicaA == 'PRODUCTOS') continue; // product-specific only, skip

      if (promo.aplicaA == 'CATEGORIAS') {
        final allowedCatIds = await _dao.getCategoriasForPromo(promo.id);
        if (!allowedCatIds.contains(categoriaId)) continue;
      }
      // aplicaA == 'TODOS' also qualifies

      if (best == null || promo.prioridad > best.prioridad) {
        best = promo;
      }
    }
    return best;
  }

  // ── Price calculation ───────────────────────────────────────────────────

  /// Calculates the final price after applying the promotion, respecting
  /// the precioMinimoFinal floor (product can never go below that value).
  double applyPromotion(PromocionesCacheData promo, double basePrice) {
    double discounted;

    if (promo.tipoDescuento == 'PORCENTAJE') {
      discounted = basePrice - (basePrice * (promo.valor / 100));
    } else if (promo.tipoDescuento == 'MONTO' || promo.tipoDescuento == 'MONTO_FIJO') {
      discounted = basePrice - promo.valor;
    } else {
      return basePrice;
    }

    // Enforce minimum final price from the promotion config
    final floor = promo.precioMinimoFinal;
    if (floor != null && floor > 0) {
      if (discounted < floor) discounted = floor;
    }

    // Safety net: never go below 0
    if (discounted < 0) discounted = 0;

    return discounted;
  }

  Future<double> evaluatePrice(int productoId, int categoriaId, double basePrice) async {
    final bestPromo = await getBestPromotion(productoId, categoriaId);
    if (bestPromo == null) return basePrice;
    return applyPromotion(bestPromo, basePrice);
  }

  /// Returns the discount description string, e.g. "-20%" or "-DOP$100"
  String promoLabel(PromocionesCacheData promo) {
    if (promo.tipoDescuento == 'PORCENTAJE') {
      return '${promo.valor.toStringAsFixed(0)}% OFF';
    } else {
      return '-\$${promo.valor.toStringAsFixed(0)}';
    }
  }

  // ── Time eligibility ────────────────────────────────────────────────────

  bool isPromotionTimeEligible(PromocionesCacheData promo, DateTime now) {
    if (promo.fechaFin != null && now.isAfter(promo.fechaFin!)) return false;
    if (now.isBefore(promo.fechaInicio)) return false;
    
    if (promo.aplicaHappyHour) {
      if (promo.horaInicioHh != null && promo.horaFinHh != null) {
        try {
          final partsInicio = promo.horaInicioHh!.split(':');
          final partsFin = promo.horaFinHh!.split(':');
          final startH = int.parse(partsInicio[0]);
          final startM = int.parse(partsInicio[1]);
          final endH = int.parse(partsFin[0]);
          final endM = int.parse(partsFin[1]);
          
          final start = DateTime(now.year, now.month, now.day, startH, startM);
          final end = DateTime(now.year, now.month, now.day, endH, endM);
          
          if (now.isBefore(start) || now.isAfter(end)) return false;
        } catch(e) {
          debugPrint('Error parsing happy hour time: $e');
        }
      }
    }
    
    return true;
  }
}
