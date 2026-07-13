// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../data/database/app_database.dart';
import '../../../data/api/dto/api_models.dart';
import '../../../shared/widgets/gradient_button.dart';
class BillSummaryScreen extends ConsumerStatefulWidget {
  const BillSummaryScreen({super.key});
  @override
  ConsumerState<BillSummaryScreen> createState() => _BillSummaryScreenState();
}
class _BillSummaryScreenState extends ConsumerState<BillSummaryScreen> {
  final _uuid = const Uuid();
  int _tipIndex = 1; 
  final _tipPcts = [5, 10, 15, -1];
  final _customTipController = TextEditingController();
  double _customTipAmount = 0.0;
  bool _requestingWaiter = false;
  bool _confirming = false;
  bool _paymentPending = false;
  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }
  void _showDialog(String title, String body, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: AppColors.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                if (isSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.epilogue(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isSuccess ? AppColors.success : AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSuccess
                              ? AppColors.success
                              : AppColors.surfaceContainerHighest,
                      foregroundColor:
                          isSuccess ? AppColors.onSuccess : AppColors.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'CONTINUE',
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final activeOrderAsync = ref.watch(activeOrderProvider);
    final activeOrder = activeOrderAsync.maybeWhen(
      data: (order) => order,
      orElse: () => null,
    );
    final activeSession = ref
        .watch(activeSessionProvider)
        .maybeWhen(data: (session) => session, orElse: () => null);
    final orderDetails =
        activeOrder != null
            ? ref.watch(orderDetailsProvider(activeOrder.facturaLocalUuid))
            : const AsyncValue.data([]);
    final mesa = ref.watch(activeMesaProvider);
    final tableNum = mesa.when(
      data: (m) => m?.numeroMesa ?? 5,
      loading: () => 5,
      error: (_, __) => 5,
    );
    final isOrderLocked =
        activeOrder?.estadoCuenta == 'POR_FACTURAR' ||
        activeOrder?.estadoCuenta == 'PENDING_PAYMENT';
    if (activeOrder == null && _paymentPending) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _paymentPending = false);
      });
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOCTURNAL',
                        style: GoogleFonts.epilogue(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'TABLE $tableNum  •  LIVE BILL',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: cartItems.when(
                data: (items) {
                  double currentRoundSubtotal = 0;
                  double currentRoundTaxes = 0;
                  for (final i in items) {
                    currentRoundSubtotal += i.subtotalLinea;
                    currentRoundTaxes += i.montoImpuesto;
                  }
                  final baseSubtotal = activeOrder?.subtotal ?? 0.0;
                  final baseTaxes = activeOrder?.totalImpuestos ?? 0.0;
                  final totalSubtotal = baseSubtotal + currentRoundSubtotal;
                  final totalTaxes = baseTaxes + currentRoundTaxes;
                  final legalTip = totalSubtotal * 0.10;
                  final extraTip =
                      _tipPcts[_tipIndex] == -1
                          ? _customTipAmount
                          : totalSubtotal * _tipPcts[_tipIndex] / 100;
                  final total =
                      totalSubtotal + totalTaxes + legalTip + extraTip;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL TO PAY',
                                    style: GoogleFonts.manrope(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'incl. taxes & tip',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      color: AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: GoogleFonts.epilogue(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed:
                                activeOrder == null ||
                                        isOrderLocked ||
                                        _paymentPending
                                    ? null
                                    : () {
                                        if (items.isNotEmpty) {
                                          _showDialog(
                                            'Pending Items',
                                            'There are unconfirmed items in your order. Please confirm or remove them before requesting payment.',
                                          );
                                          return;
                                        }
                                        _requestPayment(
                                          activeOrder,
                                          activeSession,
                                          tableNum,
                                        );
                                      },
                            icon: const Icon(Icons.credit_score, size: 16),
                            label: Text(
                              (_paymentPending || isOrderLocked)
                                  ? 'PAYMENT REQUESTED'
                                  : 'PAY & CLOSE ACCOUNT',
                              style: GoogleFonts.epilogue(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.surfaceContainerLowest,
                              disabledBackgroundColor:
                                  AppColors.surfaceContainerHigh,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed:
                                _requestingWaiter
                                    ? null
                                    : () async {
                                      setState(() => _requestingWaiter = true);
                                      try {
                                        final api = ref.read(
                                          apiServiceProvider,
                                        );
                                        await api.llamarMesero(
                                          tableNum,
                                          LlamarMeseroRequest(
                                            motivo_llamada: 'ASISTENCIA_MESA',
                                          ),
                                        );
                                        if (mounted)
                                          _showDialog(
                                            '🔔 Waiter Called',
                                            'Your waiter has been notified and will arrive shortly!',
                                            isSuccess: true,
                                          );
                                      } catch (e) {
                                        if (mounted)
                                          _showDialog(
                                            'Failed',
                                            'Could not reach the waiter: $e',
                                          );
                                      } finally {
                                        if (mounted)
                                          setState(
                                            () => _requestingWaiter = false,
                                          );
                                      }
                                    },
                            icon:
                                _requestingWaiter
                                    ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.onSurface,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.back_hand_outlined,
                                      size: 16,
                                    ),
                            label: Text(
                              'REQUEST WAITER',
                              style: GoogleFonts.epilogue(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surfaceContainerHigh,
                              foregroundColor: AppColors.onSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: AppColors.outlineVariant.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Opacity(
                          opacity: (_paymentPending || isOrderLocked) ? 0.4 : 1.0,
                          child: IgnorePointer(
                            ignoring: _paymentPending || isOrderLocked,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.volunteer_activism,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'ADDITIONAL TIP',
                                      style: GoogleFonts.epilogue(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(_tipPcts.length, (i) {
                                    final sel = i == _tipIndex;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _tipIndex = i),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 150),
                                          margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                sel
                                                    ? AppColors.primaryContainer
                                                    : AppColors.surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color:
                                                  sel
                                                      ? AppColors.primaryContainer
                                                      : AppColors.outlineVariant
                                                          .withValues(alpha: 0.15),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _tipPcts[i] == -1
                                                  ? 'Custom'
                                                  : '${_tipPcts[i]}%',
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    sel
                                                        ? AppColors.onPrimaryContainer
                                                        : AppColors.onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                if (_tipPcts[_tipIndex] == -1) ...[
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _customTipController,
                                    keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'),
                                      ),
                                    ],
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurface,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter tip amount',
                                      hintStyle: GoogleFonts.manrope(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.attach_money,
                                        size: 16,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surfaceContainerHigh,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _customTipAmount = double.tryParse(val) ?? 0.0;
                                      });
                                    },
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.payments,
                                        size: 16,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Extra tip: \$${extraTip.toStringAsFixed(2)}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              _billRow(
                                'Subtotal',
                                '\$${totalSubtotal.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _billRow(
                                'ITBIS (18%)',
                                '\$${totalTaxes.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _billRow(
                                'Legal Tip (10%)',
                                '\$${legalTip.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _billRow(
                                'Extra Tip (${_tipPcts[_tipIndex] == -1 ? 'Custom' : '${_tipPcts[_tipIndex]}%'})',
                                '\$${extraTip.toStringAsFixed(2)}',
                              ),
                              Divider(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.15,
                                ),
                                height: 20,
                              ),
                              _billRow(
                                'TOTAL',
                                '\$${total.toStringAsFixed(2)}',
                                bold: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_paymentPending || isOrderLocked)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              'Waiting for payment confirmation. No further changes allowed.',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'NEW ROUND (TO CONFIRM)',
                              style: GoogleFonts.epilogue(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${items.length} items',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (items.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.add_shopping_cart,
                                  size: 36,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No pending items yet',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Select drinks or dishes from the menu to confirm them.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          ...items.map(
                            (item) =>
                                _cartItem(item, removable: !isOrderLocked),
                          ),
                          const SizedBox(height: 16),
                          GradientButton(
                            text:
                                isOrderLocked
                                    ? 'ORDERING LOCKED'
                                    : (_confirming
                                        ? 'CONFIRMING...'
                                        : 'CONFIRM ORDER (${items.length} ITEMS)'),
                            onPressed:
                                items.isEmpty || _confirming || isOrderLocked
                                    ? null
                                    : () => _confirmItems(
                                      items,
                                      activeOrder,
                                      activeSession,
                                      tableNum,
                                    ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFB693), Color(0xFFFF6B00)],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ACCOUNT SUMMARY (CONFIRMED)',
                              style: GoogleFonts.epilogue(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        orderDetails.when(
                          data: (confirmedItems) {
                            if (confirmedItems.isEmpty) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.receipt_long,
                                      size: 36,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No confirmed items yet',
                                      style: GoogleFonts.manrope(
                                        color: AppColors.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Confirmed items will appear here once your order is sent.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children:
                                  confirmedItems
                                      .map((item) => _confirmedItem(item))
                                      .toList(),
                            );
                          },
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                          error:
                              (e, __) => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  'Error loading confirmed items',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                error: (e, __) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _billRow(String label, String value, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: bold ? AppColors.onSurface : AppColors.onSurfaceVariant,
        ),
      ),
      Text(
        value,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: AppColors.onSurface,
        ),
      ),
    ],
  );
  Widget _cartItem(item, {bool removable = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_bar,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nombreProducto,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.cantidad}  •  \$${item.precioUnitario.toStringAsFixed(2)}',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.subtotalLinea.toStringAsFixed(2)}',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 6),
              if (removable)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (item.cantidad > 1) {
                          await ref.read(carritoDaoProvider).updateQuantity(item.id, item.cantidad - 1);
                        } else {
                          await ref.read(carritoDaoProvider).removeItem(item.id);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: AppColors.error,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        await ref.read(carritoDaoProvider).removeItem(item.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _confirmedItem(HistorialDetalle item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.secondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productoNombre,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.cantidad}  •  \$${item.precioUnitario.toStringAsFixed(2)}',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${item.subtotalLinea.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _confirmItems(
    List<CarritoLocalData> items,
    HistorialPedido? activeOrder,
    SesionClienteData? activeSession,
    int numeroMesa,
  ) async {
    if (items.isEmpty) return;

    if (activeSession == null || activeSession.clienteId == null) {
      _showDialog(
        'Sign In Required',
        'Please sign in again to confirm your order.',
      );
      return;
    }

    setState(() => _confirming = true);

    final api = ref.read(apiServiceProvider);
    final historialDao = ref.read(historialDaoProvider);
    final carritoDao = ref.read(carritoDaoProvider);

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.subtotalLinea,
    );
    final totalImpuestos = items.fold<double>(
      0,
      (sum, item) => sum + item.montoImpuesto,
    );

    final propinaLegal = double.parse((subtotal * 0.10).toStringAsFixed(2));
    final totalGeneral = double.parse(
      (subtotal + totalImpuestos + propinaLegal).toStringAsFixed(2),
    );

    final uuid = activeOrder?.facturaLocalUuid ?? _uuid.v4();

    final itemsConNuevosIds = items.map((item) {
      return {
        'item': item,
        'nuevo_detalle_uuid': _uuid.v4(), 
      };
    }).toList();

    final detallesCreate = itemsConNuevosIds.map((mapData) {
      final item = mapData['item'] as CarritoLocalData;
      final nuevoId = mapData['nuevo_detalle_uuid'] as String;

      return DetallePedidoCreate(
        detalle_local_uuid: nuevoId,
        producto_id: item.productoId,
        cantidad: item.cantidad,
        precio_unitario: item.precioUnitario,
        monto_impuesto: item.montoImpuesto,
        subtotal_linea: double.parse(
          (item.subtotalLinea + item.montoImpuesto).toStringAsFixed(2),
        ),
      );
    }).toList();

    final detallesAdicional = itemsConNuevosIds.map((mapData) {
      final item = mapData['item'] as CarritoLocalData;
      final nuevoId = mapData['nuevo_detalle_uuid'] as String;

      return DetalleItemAdicional(
        detalle_local_uuid: nuevoId,
        producto_id: item.productoId,
        cantidad: item.cantidad,
        precio_unitario: item.precioUnitario,
        monto_impuesto: item.montoImpuesto,
        subtotal_linea: double.parse(
          (item.subtotalLinea + item.montoImpuesto).toStringAsFixed(2),
        ),
      );
    }).toList();

    // Snapshot the cart items NOW (before clearCart) so we can restore
    // them if the user cancels within the 90-second window.
    final cartSnapshot = List<CarritoLocalData>.from(items);

    try {
      if (activeOrder == null) {
        final request = PedidoCreateRequest(
          mesa: numeroMesa,
          cliente_id: activeSession.clienteId!,
          canal_origen: 'MOVIL',
          factura_local_uuid: uuid,
          subtotal: subtotal,
          total_impuestos: totalImpuestos,
          total_general: double.parse(
            (subtotal + totalImpuestos).toStringAsFixed(2),
          ),
          propina_extra: 0.0,
          detalles: detallesCreate,
        );

        await api.crearPedido(request);

        await historialDao.createOrder(
          HistorialPedidosCompanion.insert(
            facturaLocalUuid: uuid,
            clienteId: Value(activeSession.clienteId),
            numeroMesa: numeroMesa,
            subtotal: subtotal,
            totalImpuestos: totalImpuestos,
            propinaLegal: propinaLegal,
            totalGeneral: totalGeneral,
          ),
          itemsConNuevosIds.map((mapData) {
            final item = mapData['item'] as CarritoLocalData;
            final nuevoId = mapData['nuevo_detalle_uuid'] as String;

            return HistorialDetallesCompanion.insert(
              detalleLocalUuid: nuevoId,
              facturaLocalUuid: uuid,
              productoId: item.productoId,
              productoNombre: item.nombreProducto,
              cantidad: item.cantidad,
              precioUnitario: item.precioUnitario,
              montoImpuesto: item.montoImpuesto,
              subtotalLinea: item.subtotalLinea,
            );
          }).toList(),
        );

        // ── Start the 90-second cancellation window ──────────────────────
        // Only for brand-new orders (not when adding items to an existing one).
        ref.read(cancellationProvider.notifier).startTimer(uuid, cartSnapshot);

      } else {
        final request = AgregarItemsRequest(
          cliente_id: activeSession.clienteId!,
          detalles_adicionales: detallesAdicional,
          nuevo_subtotal_agregado: subtotal,
          nuevo_impuesto_agregado: totalImpuestos,
        );

        final response = await api.agregarAPedido(
          activeOrder.facturaLocalUuid,
          request,
        );

        await historialDao.appendOrderDetails(
          activeOrder.facturaLocalUuid,
          itemsConNuevosIds.map((mapData) {
            final item = mapData['item'] as CarritoLocalData;
            final nuevoId = mapData['nuevo_detalle_uuid'] as String;

            return HistorialDetallesCompanion.insert(
              detalleLocalUuid: nuevoId,
              facturaLocalUuid: activeOrder.facturaLocalUuid,
              productoId: item.productoId,
              productoNombre: item.nombreProducto,
              cantidad: item.cantidad,
              precioUnitario: item.precioUnitario,
              montoImpuesto: item.montoImpuesto,
              subtotalLinea: item.subtotalLinea,
            );
          }).toList(),
        );

        await historialDao.updateOrderTotals(
          facturaUuid: activeOrder.facturaLocalUuid,
          newSubtotal:
              response.nuevo_subtotal ??
              double.parse(
                (activeOrder.subtotal + subtotal).toStringAsFixed(2),
              ),
          newTotalImpuestos:
              response.nuevo_total_impuestos ??
              double.parse(
                (activeOrder.totalImpuestos + totalImpuestos).toStringAsFixed(2),
              ),
          newTotalGeneral:
              response.nuevo_total_general ??
              double.parse(
                (activeOrder.totalGeneral + totalGeneral).toStringAsFixed(2),
              ),
        );
      }

      await carritoDao.clearCart();

      if (mounted) {
        _showDialog(
          'Order Confirmed',
          'Your items were successfully added to the account.',
          isSuccess: true,
        );
      }
    } catch (error) {
      if (mounted) {
        _showDialog('Confirmation Failed', 'Error: $error');
      }
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Future<void> _requestPayment(
    HistorialPedido activeOrder,
    SesionClienteData? activeSession,
    int numeroMesa,
  ) async {
    if (activeSession == null || activeSession.clienteId == null) {
      _showDialog(
        'Sign In Required',
        'Please sign in again to request payment.',
      );
      return;
    }
    setState(() => _paymentPending = true);

    // Stop the cancellation window immediately — payment flow takes over.
    ref.read(cancellationProvider.notifier).stopTimer();

    final api = ref.read(apiServiceProvider);
    final historialDao = ref.read(historialDaoProvider);
    final extraTip =
        _tipPcts[_tipIndex] == -1
            ? _customTipAmount
            : (_tipPcts[_tipIndex] / 100) * activeOrder.subtotal;
    try {
      await api.solicitarCuenta(
        activeOrder.facturaLocalUuid,
        SolicitarCuentaRequest(
          metodo_pago_preferido: 'EFECTIVO',
          propina_extra: double.parse(extraTip.toStringAsFixed(2)),
        ),
      );
      final remoteResumen = await api.getResumenCuenta(activeOrder.facturaLocalUuid);
      await historialDao.syncExistingOrder(
        clienteId: activeSession.clienteId!,
        numeroMesa: numeroMesa,
        facturaUuid: remoteResumen.factura_local_uuid,
        subtotal: remoteResumen.subtotal_acumulado,
        totalImpuestos: remoteResumen.total_impuestos_acumulado,
        propinaLegal: remoteResumen.propina_legal_acumulada,
        totalGeneral: remoteResumen.total_general_acumulado,
        estadoCuenta: 'PENDING_PAYMENT',
        items: remoteResumen.items_consumidos,
        propinaVoluntaria: double.parse(extraTip.toStringAsFixed(2)),
      );
      if (mounted) {
        _showDialog(
          'Payment Requested',
          'The bar has been notified and will process your payment soon.',
          isSuccess: true,
        );
      }
    } catch (error) {
      if (mounted) {
        _showDialog(
          'Payment Failed',
          'Error: $error',
        );
        setState(() => _paymentPending = false);
      }
    }
  }
}
