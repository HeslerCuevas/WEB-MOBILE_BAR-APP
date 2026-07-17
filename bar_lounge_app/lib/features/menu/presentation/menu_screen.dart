import 'package:flutter/material.dart';
import '../../../core/utils/error_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/providers/providers.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/widgets/price_tag.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});
  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  int _selectedCat = -1;
  String _snack = '';
  bool _snackIsError = false;
  int _snackToken = 0;

  void _showSnack(String msg, {bool isError = false}) {
    final token = ++_snackToken;
    setState(() {
      _snack = msg;
      _snackIsError = isError;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && token == _snackToken) {
        setState(() => _snack = '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ref.watch(categoriasProvider);
    final productos = ref.watch(allProductosProvider);
    final cartCount = ref.watch(cartItemCountProvider);
    final mesa = ref.watch(activeMesaProvider);
    final activePromos = ref.watch(activePromotionsProvider);
    final activePromosList = activePromos.maybeWhen(
      data: (list) => list,
      orElse: () => <PromocionesCacheData>[],
    );

    final activeOrderAsync = ref.watch(activeOrderProvider);
    final activeOrder = activeOrderAsync.maybeWhen(
      data: (order) => order,
      orElse: () => null,
    );
    final isOrderLocked =
        activeOrder?.estadoCuenta == 'POR_FACTURAR' ||
        activeOrder?.estadoCuenta == 'PENDING_PAYMENT';
    final tableNum = mesa.when(
      data: (m) => m?.numeroMesa,
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (tableNum != null)
                        Text.rich(TextSpan(
                          text: 'Table ',
                          style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant),
                          children: [TextSpan(text: '$tableNum', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700))],
                        ))
                      else
                        Text('No Table Assigned', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w700)),
                      Text('NOCTURNAL', style: GoogleFonts.epilogue(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1)),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/orders'),
                    child: Stack(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.onSurface, size: 22),
                      ),
                      cartCount.when(
                        data: (c) => c > 0 ? Positioned(right: 0, top: 0, child: Container(
                          width: 18, height: 18,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer),
                          child: Center(child: Text('$c', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.onPrimaryContainer))),
                        )) : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ]),
                  ),
                ]),
              ),
              categorias.when(
                data: (cats) {
                  final sortedCats = List<CategoriasCacheData>.from(cats);
                  sortedCats.sort((a, b) {
                    final aPromo = ref.watch(categoryBestPromoProvider(a.id)).value;
                    final bPromo = ref.watch(categoryBestPromoProvider(b.id)).value;
                    final aHasPromo = aPromo != null ? 1 : 0;
                    final bHasPromo = bPromo != null ? 1 : 0;
                    if (aHasPromo != bHasPromo) return bHasPromo.compareTo(aHasPromo);
                    return a.nombre.compareTo(b.nombre);
                  });

                  return SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _catChip('All', -1),
                        ...sortedCats.map((c) => _catChip(c.nombre, c.id)),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox(height: 50),
                error: (_, __) => const SizedBox(height: 50),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: productos.when(
                  data: (all) {
                    final items = _selectedCat == -1
                        ? all
                        : all.where((p) => p.categoriaId == _selectedCat).toList();
                    if (items.isEmpty) {
                      return Center(child: Text('No products available', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, i) => _productCard(items[i], isOrderLocked, tableNum == null),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, __) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
                ),
              ),
            ]),
          ),
          if (_snack.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 24, right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _snackIsError
                      ? AppColors.surfaceContainerHigh
                      : AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.ctaShadow,
                ),
                child: Row(children: [
                  Icon(
                    _snackIsError ? Icons.info_outline : Icons.check_circle,
                    color: _snackIsError
                        ? AppColors.onSurface
                        : AppColors.onPrimaryContainer,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _snack,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _snackIsError
                            ? AppColors.onSurface
                            : AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool _categoryHasGlobalPromo(List<PromocionesCacheData> activePromos) {
    final evalService = ref.read(promotionsEvalServiceProvider);
    final now = DateTime.now();
    return activePromos.any((p) =>
      p.aplicaA == 'TODOS' && evalService.isPromotionTimeEligible(p, now));
  }

  // ── Category chip ─────────────────────────────────────────────────────

  Widget _catChip(String name, int id) {
    final selected = _selectedCat == id;
    
    PromocionesCacheData? syncPromo;
    if (id != -1) {
      final promoAsync = ref.watch(categoryBestPromoProvider(id));
      syncPromo = promoAsync.maybeWhen(data: (v) => v, orElse: () => null);
    }
    
    final activePromos = ref.watch(activePromotionsProvider).maybeWhen(data: (v) => v, orElse: () => <PromocionesCacheData>[]);
    final isGlobalPromo = id == -1 && _categoryHasGlobalPromo(activePromos);
    final hasPromo = isGlobalPromo || syncPromo != null;
    final isHappyHour = syncPromo?.aplicaHappyHour ?? false;

    final evalService = ref.read(promotionsEvalServiceProvider);
    String promoSuffix = "PROMO";
    if (syncPromo != null) {
      promoSuffix = evalService.promoLabel(syncPromo);
    }

    final promoColor = isHappyHour ? AppColors.secondary : const Color(0xFF00DAF8);
    final textColor = isHappyHour ? AppColors.onSecondary : AppColors.background;

    final chip = GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedCat = id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.amberGlow : null,
          color: selected ? null : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : hasPromo
                    ? promoColor
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: hasPromo && !selected ? 1.5 : 1.0,
          ),
          boxShadow: (selected)
              ? AppColors.ctaShadow
              : (hasPromo && !selected)
                  ? [BoxShadow(color: promoColor.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 1)]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasPromo && !selected) ...[
              Icon(
                isHappyHour ? Icons.celebration_rounded : Icons.local_offer_rounded, 
                size: 13, 
                color: promoColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              name.toUpperCase(),
              style: GoogleFonts.epilogue(
                fontSize: 12,
                fontWeight: selected || hasPromo ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 1.2,
                color: selected
                    ? AppColors.background
                    : hasPromo
                        ? promoColor
                        : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    if (hasPromo && !selected) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            chip,
            Positioned(
              top: -8,
              right: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: promoColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: promoColor.withValues(alpha: 0.35), blurRadius: 4)],
                ),
                child: Text(
                  promoSuffix,
                  style: GoogleFonts.epilogue(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: chip,
    );
  }

  // ── Product card ─────────────────────────────────────────────────────────
  // Uses productBestPromoProvider (FutureProvider.family) so ALL promotion
  // types are resolved — TODOS, PRODUCTOS, and CATEGORIAS.

  Widget _productCard(ProductosCacheData p, bool isOrderLocked, bool isTableMissing) {
    final promoKey = ProductPromoKey(p.id, p.categoriaId);
    final promoAsync = ref.watch(productBestPromoProvider(promoKey));
    final evalService = ref.read(promotionsEvalServiceProvider);

    // Resolve promo synchronously from provider cache (null while loading)
    final syncPromo = promoAsync.maybeWhen(data: (v) => v, orElse: () => null);
    final hasDiscount = syncPromo != null;
    final finalPrice = syncPromo != null
        ? evalService.applyPromotion(syncPromo, p.precioBase)
        : p.precioBase;
    final discountLabel = syncPromo != null ? evalService.promoLabel(syncPromo) : null;

    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: hasDiscount
            ? Border.all(
                color: syncPromo.aplicaHappyHour
                    ? AppColors.secondary.withValues(alpha: 0.45)
                    : AppColors.tertiary.withValues(alpha: 0.35),
                width: 1.0,
              )
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: hasDiscount
                ? (syncPromo.aplicaHappyHour
                    ? AppColors.secondary.withValues(alpha: 0.10)
                    : AppColors.tertiary.withValues(alpha: 0.08))
                : Colors.black.withValues(alpha: 0.3),
            blurRadius: hasDiscount ? 14 : 10,
          ),
        ],
      ),
      child: Row(children: [
        // Image with optional discount badge overlay
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: Stack(
            children: [
              SizedBox(
                width: 120, height: 130,
                child: Image.network(
                  p.imagenUrl ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Container(
                          color: AppColors.surfaceContainerHigh,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                        ),
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Icon(Icons.local_bar, color: AppColors.primary, size: 36),
                  ),
                ),
              ),
              // Discount badge on image
              if (hasDiscount)
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: syncPromo.aplicaHappyHour
                          ? AppColors.goldGradient
                          : const LinearGradient(
                              colors: [Color(0xFF00DAF8), Color(0xFF00A8C0)],
                            ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: (syncPromo.aplicaHappyHour ? AppColors.secondary : AppColors.tertiary).withValues(alpha: 0.35),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      discountLabel!,
                      style: GoogleFonts.epilogue(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: syncPromo.aplicaHappyHour
                            ? AppColors.onSecondary
                            : AppColors.onTertiary,
                      ),
                    ),
                  ),
                ),
              if (hasDiscount && syncPromo.aplicaHappyHour)
                Positioned(
                  bottom: 6, left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '⭐ HAPPY HOUR',
                      style: GoogleFonts.manrope(fontSize: 7.5, fontWeight: FontWeight.w700, color: AppColors.secondary),
                    ),
                  ),
                ),
              // Out of stock or low stock indicator
              if (p.cantidadDisponible != null)
                Positioned(
                  bottom: 6, right: 6,
                  child: p.cantidadDisponible! <= 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                        child: Text('OUT OF STOCK', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                      )
                    : (p.cantidadDisponible! <= 5
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                            child: Text('ONLY ${p.cantidadDisponible} LEFT', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                          )
                        : const SizedBox.shrink()),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.nombre, overflow: TextOverflow.ellipsis, maxLines: 1,
                    style: GoogleFonts.epilogue(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text(p.descripcion ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.3)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Price block — discounted or normal
                if (!hasDiscount)
                  _PriceTag(amount: p.precioBase)
                else
                  _DiscountedPriceBlock(
                    originalPrice: p.precioBase,
                    finalPrice: finalPrice,
                    promo: syncPromo,
                  ),
                _AnimatedAddButton(
                  onTap: p.cantidadDisponible != null && p.cantidadDisponible! <= 0 ? null : () async {
                    if (isTableMissing) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('No Table Assigned', style: GoogleFonts.epilogue(fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                          content: Text('Please scan a table QR code or enter one manually in the Scanner screen to order.', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('OK', style: GoogleFonts.epilogue(fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    if (isOrderLocked) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('Ordering Locked', style: GoogleFonts.epilogue(fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                          content: Text('You need to pay your order first.', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('OK', style: GoogleFonts.epilogue(fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    // Full async lookup (already cached by provider — instant on second call)
                    final promo = await ref.read(promotionsEvalServiceProvider).getBestPromotion(p.id, p.categoriaId);
                    double cartPrice = p.precioBase;
                    if (promo != null) {
                      cartPrice = ref.read(promotionsEvalServiceProvider).applyPromotion(promo, p.precioBase);
                    }

                    try {
                      await ref.read(carritoDaoProvider).addItem(
                        productoId: p.id,
                        nombreProducto: p.nombre,
                        precioUnitario: cartPrice,
                        tasaImpuesto: p.tasaImpuesto,
                      );
                      _showSnack('${p.nombre} added to cart!');
                    } catch (e) {
                      _showSnack(
                        ErrorHandler.getMessage(
                          e,
                          fallback: 'Could not add this item right now.',
                        ),
                        isError: true,
                      );
                    }
                  },
                ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Price widgets ───────────────────────────────────────────────────────────

class _PriceTag extends StatelessWidget {
  final double amount;
  const _PriceTag({required this.amount});

  @override
  Widget build(BuildContext context) {
    return PriceTag(amount: amount);
  }
}

class _DiscountedPriceBlock extends StatelessWidget {
  final double originalPrice;
  final double finalPrice;
  final PromocionesCacheData promo;
  const _DiscountedPriceBlock({
    required this.originalPrice,
    required this.finalPrice,
    required this.promo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PriceTag(
          amount: originalPrice,
          isStrikethrough: true,
        ),
        PriceTag(
          amount: finalPrice,
          isDiscounted: true,
        ),
      ],
    );
  }
}

// ── Animated add button ─────────────────────────────────────────────────────

class _AnimatedAddButton extends StatefulWidget {
  final VoidCallback? onTap;
  const _AnimatedAddButton({this.onTap});
  @override
  State<_AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<_AnimatedAddButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _isPressed = true),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _isPressed = false),
      onTap: widget.onTap == null ? null : () async {
        widget.onTap!();
        setState(() => _isPressed = true);
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isPressed
                ? []
                : [BoxShadow(color: AppColors.primaryContainer.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.add, color: AppColors.onPrimaryContainer, size: 22),
        ),
      ),
    );
  }
}


