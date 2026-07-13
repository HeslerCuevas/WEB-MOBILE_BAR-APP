import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/providers/providers.dart';

/// "Forgot password" screen — the user enters their email and we call
/// POST /clientes/auth/solicitar-reset.  The CORE sends them an email with
/// a deep-link that opens the app at /confirm-reset?token=...
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent    = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    setState(() {
      _loading = true;
      _error   = null;
    });
    try {
      final api = ref.read(apiServiceProvider);
      await api.solicitarReset(email);
      if (mounted) setState(() => _sent = true);
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['detail'] as String?;
      if (mounted) {
        setState(() => _error = msg ?? 'Something went wrong. Please try again.');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
        title: Text(
          'NOCTURNAL',
          style: GoogleFonts.epilogue(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.surfaceContainerLow),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -1.1),
            radius: 1.05,
            colors: [
              AppColors.primaryContainer.withValues(alpha: 0.035),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 36),
            child: _sent ? _buildSuccessState() : _buildFormState(),
          ),
        ),
      ),
    );
  }

  // ── Success state ─────────────────────────────────────────────────────────

  Widget _buildSuccessState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withValues(alpha: 0.12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
          ),
          child: const Icon(Icons.mark_email_read_outlined,
              color: AppColors.success, size: 36),
        ),
        const SizedBox(height: 28),
        Text(
          'Check Your\nEmail',
          textAlign: TextAlign.center,
          style: GoogleFonts.epilogue(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'If that email is linked to a Nocturnal account, you\'ll receive a reset link shortly.\n\nTap the button in the email to open the app and set your new password.',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 15,
            height: 1.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 44),
        GradientButton(
          text: 'BACK TO LOGIN',
          icon: Icons.login_outlined,
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }

  // ── Form state ────────────────────────────────────────────────────────────

  Widget _buildFormState() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainer,
            border: Border.all(color: AppColors.surfaceContainerHighest),
          ),
          child: const Icon(Icons.lock_reset_outlined,
              color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: 28),
        Text(
          'Forgot\nPassword?',
          textAlign: TextAlign.center,
          style: GoogleFonts.epilogue(
            fontSize: 46,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'No worries — enter the email linked to your Nocturnal account and we\'ll send you a reset link.',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 16,
            height: 1.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(
                        fontSize: 12, color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 42),
        _label('EMAIL ADDRESS'),
        const SizedBox(height: 10),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.manrope(
              color: AppColors.onSurface, fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'name@domain.com',
            prefixIcon: Icon(Icons.alternate_email,
                color: AppColors.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 34),
        GradientButton(
          text: _loading ? 'SENDING...' : 'SEND RESET LINK',
          icon: Icons.send_outlined,
          onPressed: _loading ? null : _submit,
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(
            'Back to Login',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
