import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/api/dto/api_models.dart';
import '../../../data/providers/providers.dart';

/// QR Scanner screen — visually identical to the original design.
///
/// Expected QR URL format:
///   https://nocturnal-bar.app/scan?sucursal=1&mesa=5&token=abc123
///
/// Flow:
///   1. Camera detects QR → stops camera to prevent duplicate scans.
///   2. Parses URL, extracts [sucursalId], [mesaId], and [qrToken].
///   3. Updates [sessionProvider] with the scanned IDs.
///   4. Calls [vincularMesa] API to bind the table server-side.
///   5. Navigates to /menu and shows a SnackBar with "Mesa X vinculada".
///   6. On error → shows error SnackBar and restarts camera.
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with SingleTickerProviderStateMixin {
  // ── Camera controller ──────────────────────────────────────────────────────
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  // ── Manual entry fallback ──────────────────────────────────────────────────
  final _tableCtrl = TextEditingController();

  // ── Pulse animation (same as original) ────────────────────────────────────
  late AnimationController _pulse;
  late Animation<double> _anim;

  // ── State ──────────────────────────────────────────────────────────────────
  bool _loading = false;
  String? _error;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _anim = Tween(
      begin: 0.3,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _tableCtrl.dispose();
    _pulse.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // QR Detection callback
  // ─────────────────────────────────────────────────────────────────────────

  void _onDetect(BarcodeCapture capture) {
    if (_loading) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    // Stop camera immediately to prevent duplicate scans.
    _cameraController.stop();
    _handleScannedValue(rawValue);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Core processing
  // ─────────────────────────────────────────────────────────────────────────

  /// Parses [rawValue] as a URL and extracts sucursal + mesa query params.
  void _handleScannedValue(String rawValue) {
    final uri = Uri.tryParse(rawValue);

    if (uri == null ||
        !uri.queryParameters.containsKey('sucursal') ||
        !uri.queryParameters.containsKey('mesa') ||
        !uri.queryParameters.containsKey('token')) {
      _showErrorSnackBar(
        'Invalid QR. Should be like: ...?sucursal=X&mesa=Y&token=Z',
      );
      _cameraController.start();
      return;
    }

    final sucursalId = int.tryParse(uri.queryParameters['sucursal']!);
    final mesaId = int.tryParse(uri.queryParameters['mesa']!);
    final qrToken = uri.queryParameters['token']?.trim();

    if (sucursalId == null ||
        mesaId == null ||
        qrToken == null ||
        qrToken.isEmpty ||
        sucursalId <= 0 ||
        mesaId <= 0) {
      _showErrorSnackBar(
        'Invalid QR parameters. Check the mesa QR and try again.',
      );
      _cameraController.start();
      return;
    }

    _processTableLinked(
      sucursalId: sucursalId,
      mesaId: mesaId,
      qrToken: qrToken,
    );
  }

  /// Performs the full table-linking flow.
  Future<void> _processTableLinked({
    required int sucursalId,
    required int mesaId,
    required String qrToken,
  }) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1. Update global session state.
      ref
          .read(sessionProvider.notifier)
          .setSession(sucursalId: sucursalId, mesaId: mesaId);

      // 2. Call the backend vincularMesa endpoint.
      final api = ref.read(apiServiceProvider);
      final resp = await api.vincularMesa(
        VincularMesaRequest(
          codigo_qr_mesa: qrToken,
          numero_mesa: mesaId,
        ),
      );

      // 3. Persist the active mesa in the local database.
      await ref
          .read(mesaDaoProvider)
          .linkTable(
            numeroMesa: mesaId,
            codigoQr: qrToken,
            facturaUuid: resp.factura_local_uuid_activa,
          );

      // 4. If there is an active factura, sync the order summary locally.
      if (resp.factura_local_uuid_activa != null) {
        try {
          final session = await ref.read(sesionDaoProvider).getActiveSession();
          if (session?.clienteId != null) {
            final sum = await api.getResumenCuenta(
              resp.factura_local_uuid_activa!,
            );
            await ref
                .read(historialDaoProvider)
                .syncExistingOrder(
                  clienteId: session!.clienteId!,
                  numeroMesa: mesaId,
                  facturaUuid: resp.factura_local_uuid_activa!,
                  subtotal: sum.subtotal_acumulado,
                  totalImpuestos: sum.total_impuestos_acumulado,
                  propinaLegal: sum.propina_legal_acumulada,
                  totalGeneral: sum.total_general_acumulado,
                  estadoCuenta: sum.estado_cuenta,
                  items: sum.items_consumidos,
                );
          }
        } catch (e) {
          // Non-fatal: summary sync failure should not block navigation.
          debugPrint('[QRScanner] Order summary sync skipped: $e');
        }
      }

      // 5. Navigate and show success feedback.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  'Table $mesaId linked',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2ECC71),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
        context.go('/menu');
      }
    } catch (e) {
      debugPrint('[QRScanner] Error linking table: $e');
      setState(() => _error = ErrorHandler.getMessage(e, fallback: 'Failed to link table. Try again.'));
      // Restart camera so the user can retry.
      _cameraController.start();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Manual entry fallback (same as original _confirmTable)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _confirmTable() async {
    final raw = _tableCtrl.text.trim();
    final mesaId = int.tryParse(raw);
    if (mesaId == null || mesaId <= 0) {
      setState(() => _error = 'Enter a valid table number.');
      return;
    }
    // Default sucursalId = 1 for manual entry.
    await _processTableLinked(
      sucursalId: 1,
      mesaId: mesaId,
      qrToken: 'MESA-${mesaId.toString().padLeft(2, '0')}',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    setState(() => _error = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.manrope(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build — visually identical to the original scanner_screen design
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemCountProvider);
    final mesa = ref.watch(activeMesaProvider);
    final tableNum = mesa.when(
      data: (m) => m?.numeroMesa,
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
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

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                    child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Viewfinder — same visual as original ──────────────────
                    AnimatedBuilder(
                      animation: _anim,
                      builder:
                          (_, __) => Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.black.withValues(alpha: 0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryContainer.withValues(
                                    alpha: _anim.value * 0.4,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  // ── Live camera feed (background layer) ───────────
                                  MobileScanner(
                                    controller: _cameraController,
                                    onDetect: _onDetect,
                                    errorBuilder:
                                        (context, error) => Container(
                                          color:
                                              AppColors.surfaceContainerLowest,
                                          padding: const EdgeInsets.all(20),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.no_photography_outlined,
                                                  color: AppColors.error,
                                                  size: 42,
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'Camera unavailable',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.epilogue(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Allow camera access for Nocturnal, then reopen this screen.',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 13,
                                                    height: 1.35,
                                                    color:
                                                        AppColors
                                                            .onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  ),

                                  // ── Semi-transparent scrim so icons are visible ───
                                  Container(
                                    color: Colors.black.withValues(alpha: 0.35),
                                  ),

                                  // ── Corner brackets (same as original) ────────────
                                  _corner(Alignment.topLeft),
                                  _corner(Alignment.topRight),
                                  _corner(Alignment.bottomLeft),
                                  _corner(Alignment.bottomRight),

                                  // ── Centre icon / loader (same as original) ───────
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _loading
                                            ? const CircularProgressIndicator(
                                              color: AppColors.primaryContainer,
                                            )
                                            : Icon(
                                              Icons.qr_code_scanner,
                                              size: 64,
                                              color: AppColors.primaryContainer
                                                  .withValues(alpha: 0.85),
                                            ),
                                        const SizedBox(height: 16),
                                        Text(
                                          _loading
                                              ? 'Linking Table...'
                                              : 'Tap to Scan QR Code',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.manrope(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'or enter table number below',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 24),

                    // ── Divider ───────────────────────────────────────────────
                    Text(
                      '── OR ENTER MANUALLY ──',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Error banner ──────────────────────────────────────────
                    if (_error != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Table number field ────────────────────────────────────
                    TextField(
                      controller: _tableCtrl,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.epilogue(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. 05',
                        hintStyle: GoogleFonts.epilogue(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 4,
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Confirm button ────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _confirmTable,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child:
                            _loading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  'CONFIRM TABLE',
                                  style: GoogleFonts.epilogue(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'How it works',
                            style: GoogleFonts.epilogue(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Scan the QR at your table or enter the table number manually to link your session before ordering.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              height: 1.45,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Corner bracket widget (identical to original)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _corner(Alignment alignment) {
    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border(
            top:
                isTop
                    ? const BorderSide(
                      color: AppColors.primaryContainer,
                      width: 4,
                    )
                    : BorderSide.none,
            bottom:
                !isTop
                    ? const BorderSide(
                      color: AppColors.primaryContainer,
                      width: 4,
                    )
                    : BorderSide.none,
            left:
                isLeft
                    ? const BorderSide(
                      color: AppColors.primaryContainer,
                      width: 4,
                    )
                    : BorderSide.none,
            right:
                !isLeft
                    ? const BorderSide(
                      color: AppColors.primaryContainer,
                      width: 4,
                    )
                    : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? const Radius.circular(14) : Radius.zero,
            topRight:
                isTop && !isLeft ? const Radius.circular(14) : Radius.zero,
            bottomLeft:
                !isTop && isLeft ? const Radius.circular(14) : Radius.zero,
            bottomRight:
                !isTop && !isLeft ? const Radius.circular(14) : Radius.zero,
          ),
        ),
      ),
    );
  }
}
