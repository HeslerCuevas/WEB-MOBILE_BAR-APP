import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../data/database/app_database.dart';
import '../../account/presentation/widgets/account_page_scaffold.dart';
class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}
class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  String _searchQuery = '';
  bool _showSearch = false;
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);
    final allDetailsAsync = ref.watch(allOrderDetailsProvider);
    return AccountPageScaffold(
      title: 'Past Sessions',
      brandText: normalizeBrandText(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      children: [
        Text(
          "Your curated journey through Nocturnal's finest pours.",
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child:
                    _showSearch
                        ? TextField(
                          controller: _searchController,
                          onChanged:
                              (v) => setState(
                                () => _searchQuery = v.toLowerCase(),
                              ),
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurface,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search by product name...',
                            hintStyle: GoogleFonts.manrope(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.onSurfaceVariant,
                              size: 18,
                            ),
                            filled: true,
                            fillColor: AppColors.surfaceContainerHigh,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              }),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      _showSearch
                          ? AppColors.primaryContainer
                          : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.search,
                  color:
                      _showSearch
                          ? AppColors.onPrimaryContainer
                          : AppColors.onSurface,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
          child: ordersAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return _emptyState();
                  }
                  return allDetailsAsync.when(
                    data: (allDetails) {
                      final detailsMap = <String, List<HistorialDetalle>>{};
                      for (final d in allDetails) {
                        detailsMap.putIfAbsent(d.facturaLocalUuid, () => []).add(d);
                      }
                      final filtered = _searchQuery.isEmpty
                          ? orders
                          : orders.where((o) {
                              final details = detailsMap[o.facturaLocalUuid] ?? [];
                              return details.any((d) => d.productoNombre.toLowerCase().contains(_searchQuery));
                            }).toList();
                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            'No orders match your search.',
                            style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, i) {
                          final order = filtered[i];
                          final details = detailsMap[order.facturaLocalUuid] ?? [];
                          return _orderCard(context, order, details);
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (e, __) => Center(child: Text('Error: $e', style: TextStyle(color: AppColors.error))),
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                error:
                    (e, __) => Center(
                      child: Text(
                        'Error: $e',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
              ),
        ),
      ],
    );
  }
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 16),
          Text('No sessions yet', style: GoogleFonts.epilogue(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Text(
            'Your past orders will appear here\nafter your first session.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
  Widget _orderCard(BuildContext context, HistorialPedido order, List<HistorialDetalle> details) {
    final date = DateFormat('MMM dd, yyyy').format(order.creadoEn);
    final isClosed = order.estadoCuenta == 'CERRADA' ||
        order.estadoCuenta == 'CERRADO' ||
        order.estadoCuenta == 'PAGADA' ||
        order.estadoCuenta == 'PAGADO' ||
        order.estadoCuenta == 'COMPLETADA' ||
        order.estadoCuenta == 'COMPLETADO' ||
        order.estadoCuenta == 'PENDING_PAYMENT' ||
        order.estadoCuenta == 'WAITING_PAYMENT';
    final statusLabel = (order.estadoCuenta == 'PAGADA' || order.estadoCuenta == 'PAGADO' || order.estadoCuenta == 'CERRADA' || order.estadoCuenta == 'CERRADO') ? 'PAID' : isClosed ? 'CLOSED' : 'OPEN';
    String itemPreview = 'No items';
    if (details.isNotEmpty) {
      if (details.length == 1) {
        itemPreview = details[0].productoNombre;
      } else if (details.length == 2) {
        itemPreview = '${details[0].productoNombre}, ${details[1].productoNombre}';
      } else {
        final extra = details.length - 2;
        itemPreview = '${details[0].productoNombre}, ${details[1].productoNombre}, and $extra other${extra > 1 ? 's' : ''}';
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                        date,
                        style: GoogleFonts.epilogue(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'TABLE ${order.numeroMesa}',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${order.totalGeneral.toStringAsFixed(2)}',
                      style: GoogleFonts.epilogue(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      statusLabel,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (details.isNotEmpty) ...[
                  _thumbnailStack(details),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    itemPreview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppColors.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => context.push('/order-receipt/${order.facturaLocalUuid}'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VIEW RECEIPT',
                      style: GoogleFonts.epilogue(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.receipt_outlined, size: 16, color: AppColors.onSurface),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _thumbnailStack(List<HistorialDetalle> details) {
    final count = details.length;
    final show = count.clamp(0, 2);
    final extra = count > 2 ? count - 2 : 0;
    return SizedBox(
      width: show == 2 ? 68 : 36,
      height: 36,
      child: Stack(
        children: [
          for (int i = 0; i < show; i++)
            Positioned(
              left: i * 28.0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: const Icon(Icons.local_bar, color: AppColors.primary, size: 18),
                ),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: show * 28.0 - 8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
