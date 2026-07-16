import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/providers.dart';
import '../../data/database/app_database.dart';

class CancellationBanner extends ConsumerStatefulWidget {
  const CancellationBanner({super.key});

  @override
  ConsumerState<CancellationBanner> createState() =>
      _CancellationBannerState();
}

class _CancellationBannerState extends ConsumerState<CancellationBanner>
    with SingleTickerProviderStateMixin {
  bool _cancelling = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ── Cancel action ──────────────────────────────────────────────────────────

  Future<void> _handleCancel(
    BuildContext context,
    String facturaUuid,
    List<CarritoLocalData> snapshot,
  ) async {
    if (_cancelling) return;
    HapticFeedback.mediumImpact();

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _cancelling = true);
    try {
      final api = ref.read(apiServiceProvider);
      final historialDao = ref.read(historialDaoProvider);
      final carritoDao = ref.read(carritoDaoProvider);

      // 1. Cancel on server (best-effort; proceed even if it fails since
      //    the order may not have been processed yet).
      try {
        await api.cancelarPedido(facturaUuid);
      } catch (e) {
        debugPrint('[Cancel] Server cancel failed (continuing locally): $e');
      }

      // 2. Remove from local history DB.
      await historialDao.deleteOrderByUuid(facturaUuid);

      // 3. Restore cart snapshot items.
      await carritoDao.clearCart();
      for (final item in snapshot) {
        // Re-insert each item individually so the DAO logic runs correctly.
        await carritoDao.addItemWithQuantity(
          productoId: item.productoId,
          nombreProducto: item.nombreProducto,
          precioUnitario: item.precioUnitario,
          tasaImpuesto: item.tasaImpuesto,
          cantidad: item.cantidad,
          comentarios: item.comentariosCocina,
        );
      }

      // 4. Stop the timer → hides banner.
      ref.read(cancellationProvider.notifier).stopTimer();
    } catch (e) {
      debugPrint('[Cancel] Error during cancellation: $e');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getMessage(e, fallback: 'Could not cancel order.')),
            backgroundColor: AppColors.errorContainer,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cancellation = ref.watch(cancellationProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: cancellation.isActive
          ? _buildBanner(context, cancellation)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildBanner(BuildContext context, CancellationState state) {
    final topInset = MediaQuery.of(context).padding.top;
    // Urgent colour shift: when < 15 s left, tint danger
    final isUrgent = state.secondsLeft <= 15;
    final accentColor =
        isUrgent ? AppColors.error : AppColors.primary;
    final timerColor =
        isUrgent ? AppColors.error : AppColors.primary;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(12, topInset + 4, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: isUrgent ? 0.4 : 0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isUrgent ? 0.18 : 0.10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left: icon + label + time + subtitle ─────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Row(
                  children: [
                    FadeTransition(
                      opacity: isUrgent ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                      child: Icon(
                        Icons.timer_outlined,
                        size: 13,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'PENDING ORDER',
                      style: GoogleFonts.epilogue(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Countdown
                FadeTransition(
                  opacity: isUrgent ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                  child: Text(
                    state.formattedTime,
                    style: GoogleFonts.epilogue(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: timerColor,
                      height: 1.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),

                // Subtitle
                Text(
                  'Cancel before preparation starts.',
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.65),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Right: Cancel button ─────────────────────────────────────────
          SizedBox(
            height: 42,
            child: _cancelling
                ? const SizedBox(
                    width: 42,
                    height: 42,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error,
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: state.facturaUuid == null
                        ? null
                        : () => _handleCancel(
                              context,
                              state.facturaUuid!,
                              state.cartSnapshot,
                            ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.5),
                      ),
                      backgroundColor:
                          AppColors.error.withValues(alpha: 0.08),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Cancel\nNow',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.epilogue(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
