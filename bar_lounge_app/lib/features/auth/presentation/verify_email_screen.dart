import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/providers/providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _ctrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;

  @override
  void dispose() {
    for (final c in _ctrls) { c.dispose(); }
    for (final n in _nodes) { n.dispose(); }
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _ctrls.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter the 6-digit code', style: GoogleFonts.manrope()), backgroundColor: AppColors.surfaceContainerHigh),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    // Create auth session and go to scanner
    try {
      await ref.read(sesionDaoProvider).createAuthSession(
        token: 'verified_token',
        nombre: 'New Member',
        clienteId: null,
      );
    } catch (_) {}
    setState(() => _loading = false);
    if (mounted) context.go('/scanner');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => context.pop()),
        title: Text('THE NOCTURNAL', style: GoogleFonts.epilogue(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 3, color: AppColors.primary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.verified_user, size: 12, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text('SECURITY PROTOCOL', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 2, color: AppColors.onSurfaceVariant)),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Verify Your', style: GoogleFonts.epilogue(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
          Text('Identity', style: GoogleFonts.epilogue(fontSize: 34, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, color: AppColors.primary)),
          const SizedBox(height: 12),
          Text("We've sent a 6-digit access code to your inbox.", textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5)),
          const SizedBox(height: 32),
          // ── OTP Fields ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) => SizedBox(
              width: 46, height: 56,
              child: TextField(
                controller: _ctrls[i],
                focusNode: _nodes[i],
                textAlign: TextAlign.center,
                maxLength: 1,
                autofocus: i == 0,
                keyboardType: TextInputType.number,
                style: GoogleFonts.epilogue(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '•',
                  hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.3), fontSize: 18),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.tertiary, width: 2)),
                ),
                onChanged: (v) {
                  if (v.length == 1 && i < 5) _nodes[i + 1].requestFocus();
                  if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                },
              ),
            )),
          ),
          const SizedBox(height: 28),
          GradientButton(
            text: _loading ? 'VERIFYING...' : 'VERIFY ACCESS',
            onPressed: _loading ? null : _verify,
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh, size: 14, color: AppColors.onSurfaceVariant),
              label: Text('RESEND CODE', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1, color: AppColors.onSurfaceVariant)),
            ),
            Text.rich(TextSpan(
              text: 'EXPIRES IN ',
              style: GoogleFonts.manrope(fontSize: 10, letterSpacing: 2, color: AppColors.outline),
              children: [TextSpan(text: '01:59', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700))],
            )),
          ]),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}
