import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../data/database/app_database.dart';
class OrderReceiptScreen extends ConsumerWidget {
  final String facturaUuid;
  const OrderReceiptScreen({super.key, required this.facturaUuid});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final detailsAsync = ref.watch(orderDetailsProvider(facturaUuid));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ordersAsync.when(
        data: (orders) {
          final matching = orders.where((o) => o.facturaLocalUuid == facturaUuid).toList();
          if (matching.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Text('Receipt not found.', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
              ),
            );
          }
          final order = matching.first;
          return _ReceiptBody(order: order, detailsAsync: detailsAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, __) => Center(child: Text('Error: $e', style: TextStyle(color: AppColors.error))),
      ),
    );
  }
}
class _ReceiptBody extends ConsumerWidget {
  final HistorialPedido order;
  final AsyncValue<List<HistorialDetalle>> detailsAsync;
  const _ReceiptBody({required this.order, required this.detailsAsync});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = DateFormat('MMM dd, yyyy').format(order.creadoEn).toUpperCase();
    final timeLabel = DateFormat('h:mm a').format(order.creadoEn);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/order-history');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'RECEIPT — $dateLabel',
                    style: GoogleFonts.epilogue(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: detailsAsync.when(
              data: (details) => _buildReceipt(context, details, timeLabel),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, __) => Center(child: Text('Error loading items: $e', style: TextStyle(color: AppColors.error))),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReceipt(BuildContext context, List<HistorialDetalle> details, String timeLabel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (order.estadoCuenta == 'CERRADA' || order.estadoCuenta == 'CERRADO' || order.estadoCuenta == 'PAGADA' || order.estadoCuenta == 'PAGADO')
                          ? 'ORDER FINALIZED'
                          : 'CURRENT SESSION',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: (order.estadoCuenta == 'CERRADA' || order.estadoCuenta == 'CERRADO' || order.estadoCuenta == 'PAGADA' || order.estadoCuenta == 'PAGADO')
                            ? AppColors.primary
                            : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Table ${order.numeroMesa}',
                      style: GoogleFonts.epilogue(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$timeLabel — ${(order.estadoCuenta == 'CERRADA' || order.estadoCuenta == 'CERRADO' || order.estadoCuenta == 'PAGADA' || order.estadoCuenta == 'PAGADO') ? 'Final Receipt' : 'Active Session'}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.receipt_long,
                size: 52,
                color: AppColors.surfaceContainerHigh,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                  child: Text(
                    'NOCTURNAL',
                    style: GoogleFonts.epilogue(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Divider(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.12)),
                if (details.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No items recorded.',
                      style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                    ),
                  )
                else
                  ...details.map((d) => _lineItem(d)),
                Divider(
                  height: 1,
                  color: AppColors.outlineVariant.withValues(alpha: 0.12),
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      _totalRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _totalRow('ITBIS (18%)', '\$${order.totalImpuestos.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _totalRow('Legal Tip (10%)', '\$${order.propinaLegal.toStringAsFixed(2)}'),
                      Builder(builder: (context) {
                        final tip = _resolvedExtraTip();
                        if (tip <= 0) return const SizedBox.shrink();
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            _totalRow('Extra Tip', '\$${tip.toStringAsFixed(2)}'),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL',
                          style: GoogleFonts.epilogue(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '\$${_computeTotal().toStringAsFixed(2)}',
                          style: GoogleFonts.epilogue(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: AppColors.onSurfaceVariant, size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PAYMENT METHOD',
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _paymentStatusLabel(),
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  double _resolvedExtraTip() {
    if (order.propinaVoluntaria > 0.001) return order.propinaVoluntaria;
    final derived = order.totalGeneral - order.subtotal - order.totalImpuestos - order.propinaLegal;
    return derived > 0.01 ? derived : 0.0;
  }

  double _computeTotal() {
    final base = order.subtotal + order.totalImpuestos + order.propinaLegal;
    final tip = _resolvedExtraTip();

    if (order.propinaVoluntaria > 0.001) {
      return base + order.propinaVoluntaria;
    }
    return tip > 0.01 ? order.totalGeneral : base;
  }
  String _paymentStatusLabel() {
    switch (order.estadoCuenta) {
      case 'PENDING_PAYMENT':
      case 'WAITING_PAYMENT':
        return 'Awaiting payment';
      case 'CERRADA':
      case 'CERRADO':
      case 'PAGADA':
      case 'PAGADO':
      case 'COMPLETADA':
      case 'COMPLETADO':
        return 'Paid';
      default:
        return 'Session Open';
    }
  }
  Widget _lineItem(HistorialDetalle d) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${d.cantidad}×',
              style: GoogleFonts.epilogue(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              d.productoNombre,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Text(
            '\$${d.subtotalLinea.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  Widget _totalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        ),
      ],
    );
  }
}
