import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../data/api/dto/api_models.dart';
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});
  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}
class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final _tableCtrl = TextEditingController();
  late AnimationController _pulse;
  late Animation<double> _anim;
  bool _loading = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.9).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }
  @override
  void dispose() {
    _tableCtrl.dispose();
    _pulse.dispose();
    super.dispose();
  }
  Future<void> _processTableLinked(int tableNum) async {
    final api = ref.read(apiServiceProvider);
    final session = await ref.read(sesionDaoProvider).getActiveSession();
    final resp = await api.vincularMesa(VincularMesaRequest(
      codigo_qr_mesa: 'MESA-${tableNum.toString().padLeft(2, '0')}',
      numero_mesa: tableNum,
    ));
    await ref.read(mesaDaoProvider).linkTable(
      numeroMesa: tableNum, 
      codigoQr: 'MESA-${tableNum.toString().padLeft(2, '0')}',
      facturaUuid: resp.factura_local_uuid_activa,
    );
    if (resp.factura_local_uuid_activa != null && session?.clienteId != null) {
      try {
        final sum = await api.getResumenCuenta(resp.factura_local_uuid_activa!);
        await ref.read(historialDaoProvider).syncExistingOrder(
          clienteId: session!.clienteId!,
          numeroMesa: tableNum,
          facturaUuid: resp.factura_local_uuid_activa!,
          subtotal: sum.subtotal_acumulado,
          totalImpuestos: sum.total_impuestos_acumulado,
          propinaLegal: sum.propina_legal_acumulada,
          totalGeneral: sum.total_general_acumulado,
          estadoCuenta: sum.estado_cuenta,
          items: sum.items_consumidos,
        );
      } catch (e) {
        debugPrint('Did not sync resume: $e');
      }
    }
  }
  Future<void> _confirmTable() async {
    final raw = _tableCtrl.text.trim();
    final tableNum = int.tryParse(raw);
    if (tableNum == null || tableNum <= 0) {
      setState(() => _error = 'Enter a valid table number.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await _processTableLinked(tableNum);
      if (mounted) context.go('/menu');
    } catch (e) {
      setState(() => _error = 'Failed to link table. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  void _simulateScan() async {
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      await _processTableLinked(5);
      if (mounted) context.go('/menu');
    } catch (_) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to scan.'; });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: Text('NOCTURNAL', style: GoogleFonts.epilogue(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 2)),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (_, __) => GestureDetector(
                    onTap: _loading ? null : _simulateScan,
                    child: Container(
                      width: double.infinity, height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.black.withValues(alpha: 0.4),
                        boxShadow: [BoxShadow(color: AppColors.primaryContainer.withValues(alpha: _anim.value * 0.4), blurRadius: 40, spreadRadius: 2)],
                      ),
                      child: Stack(children: [
                        _corner(Alignment.topLeft),
                        _corner(Alignment.topRight),
                        _corner(Alignment.bottomLeft),
                        _corner(Alignment.bottomRight),
                        Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                          _loading
                              ? const CircularProgressIndicator(color: AppColors.primaryContainer)
                              : Icon(Icons.qr_code_scanner, size: 64, color: AppColors.primaryContainer.withValues(alpha: 0.85)),
                          const SizedBox(height: 16),
                          Text(_loading ? 'Linking Table...' : 'Tap to Scan QR Code', textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                          const SizedBox(height: 6),
                          Text('or enter table number below', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        ])),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('── OR ENTER MANUALLY ──', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.onSurfaceVariant.withValues(alpha: 0.6))),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                      const SizedBox(width: 8),
                      Text(_error!, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.error)),
                    ]),
                  ),
                ],
                TextField(
                  controller: _tableCtrl,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.epilogue(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.onSurface, letterSpacing: 8),
                  decoration: InputDecoration(
                    hintText: '05',
                    hintStyle: GoogleFonts.epilogue(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 8, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _confirmTable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('CONFIRM TABLE', style: GoogleFonts.epilogue(fontWeight: FontWeight.w800, letterSpacing: 3)),
                  ),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
  Widget _corner(Alignment alignment) {
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    return Positioned(
      top: isTop ? 0 : null, bottom: isTop ? null : 0,
      left: isLeft ? 0 : null, right: isLeft ? null : 0,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: AppColors.primaryContainer, width: 4) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: AppColors.primaryContainer, width: 4) : BorderSide.none,
            left: isLeft ? const BorderSide(color: AppColors.primaryContainer, width: 4) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: AppColors.primaryContainer, width: 4) : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? const Radius.circular(14) : Radius.zero,
            topRight: isTop && !isLeft ? const Radius.circular(14) : Radius.zero,
            bottomLeft: !isTop && isLeft ? const Radius.circular(14) : Radius.zero,
            bottomRight: !isTop && !isLeft ? const Radius.circular(14) : Radius.zero,
          ),
        ),
      ),
    );
  }
}
