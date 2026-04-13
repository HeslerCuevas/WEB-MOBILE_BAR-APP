import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../data/database/app_database.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});
  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  int _selectedCat = -1; // -1 = all
  String _snack = '';

  void _showSnack(String msg) {
    setState(() => _snack = msg);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _snack = '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ref.watch(categoriasProvider);
    final productos = ref.watch(allProductosProvider);
    final cartCount = ref.watch(cartItemCountProvider);
    final mesa = ref.watch(activeMesaProvider);

    final activeOrderAsync = ref.watch(activeOrderProvider);
    final activeOrder = activeOrderAsync.maybeWhen(
      data: (order) => order,
      orElse: () => null,
    );
    final isOrderLocked =
        activeOrder?.estadoCuenta == 'POR_FACTURAR' ||
        activeOrder?.estadoCuenta == 'PENDING_PAYMENT';

    final tableNum = mesa.when(
      data: (m) => m?.numeroMesa ?? 5,
      loading: () => 5,
      error: (_, __) => 5,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(children: [
              // ── AppBar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text.rich(TextSpan(
                        text: 'Table ',
                        style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant),
                        children: [TextSpan(text: '$tableNum', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700))],
                      )),
                      Text('NOCTURNAL', style: GoogleFonts.epilogue(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1)),
                    ]),
                  ),
                  // Cart icon with badge
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
              // ── Category chips ──
              categorias.when(
                data: (cats) {
                  return SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _catChip('All', -1),
                        ...cats.map((c) => _catChip(c.nombre, c.id)),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox(height: 50),
                error: (_, __) => const SizedBox(height: 50),
              ),
              const SizedBox(height: 8),
              // ── Products ──
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
                      itemBuilder: (_, i) => _productCard(items[i], isOrderLocked),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, __) => Center(child: Text('Error: $e', style: TextStyle(color: AppColors.error))),
                ),
              ),
            ]),
          ),
          // ── Snack toast ──
          if (_snack.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 24, right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.ctaShadow,
                ),
                child: Row(children: [
                  const Icon(Icons.check_circle, color: AppColors.onPrimaryContainer, size: 18),
                  const SizedBox(width: 8),
                  Text(_snack, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onPrimaryContainer)),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _catChip(String name, int id) {
    final selected = _selectedCat == id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedCat = id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.amberGlow : null,
          color: selected ? null : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected 
              ? Colors.transparent 
              : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: selected ? AppColors.ctaShadow : [],
        ),
        child: Text(
          name.toUpperCase(), 
          style: GoogleFonts.epilogue(
            fontSize: 12, 
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            letterSpacing: 1.2,
            color: selected ? AppColors.background : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _productCard(ProductosCacheData p, bool isOrderLocked) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
      ),
      child: Row(children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: SizedBox(
            width: 120, height: 130,
            child: Image.network(
              p.imagenUrl ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null ? child
                  : Container(color: AppColors.surfaceContainerHigh, child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))),
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.local_bar, color: AppColors.primary, size: 36),
              ),
            ),
          ),
        ),
        // Info
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
                Text('\$${p.precioBase.toStringAsFixed(0)}',
                    style: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                // Add to cart button
                _AnimatedAddButton(
                  onTap: () async {
                    if (isOrderLocked) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            'Ordering Locked',
                            style: GoogleFonts.epilogue(
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          content: Text(
                            'You need to pay your order first.',
                            style: GoogleFonts.manrope(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'OK',
                                style: GoogleFonts.epilogue(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    try {
                      await ref.read(carritoDaoProvider).addItem(
                        productoId: p.id,
                        nombreProducto: p.nombre,
                        precioUnitario: p.precioBase,
                        tasaImpuesto: p.tasaImpuesto,
                      );
                      _showSnack('${p.nombre} added to cart!');
                    } catch (e) {
                      _showSnack('Error adding item.');
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

class _AnimatedAddButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedAddButton({required this.onTap});

  @override
  State<_AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<_AnimatedAddButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () async {
        widget.onTap();
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
