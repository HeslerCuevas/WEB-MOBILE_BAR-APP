import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/providers/providers.dart';

/// Screen that handles the deep-link from the password reset email.
///
/// Route: /confirm-reset with token query parameter
///
/// The user taps the button in the email → the app opens here with the
/// token already filled in. They enter a new password and confirm it.
/// On success we show a dialog and redirect to /login.
class ConfirmResetScreen extends ConsumerStatefulWidget {
  /// The reset token extracted from the deep-link query parameter.
  final String token;

  const ConfirmResetScreen({super.key, required this.token});

  @override
  ConsumerState<ConfirmResetScreen> createState() =>
      _ConfirmResetScreenState();
}

class _ConfirmResetScreenState extends ConsumerState<ConfirmResetScreen> {
  final _newPasswordCtrl     = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscureNew     = true;
  bool _obscureConfirm = true;
  bool _loading        = false;
  String? _error;

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // ── Validation & submission ───────────────────────────────────────────────

  Future<void> _save() async {
    final newPassword     = _newPasswordCtrl.text.trim();
    final confirmPassword = _confirmPasswordCtrl.text.trim();

    if (widget.token.isEmpty) {
      setState(() => _error = 'Invalid or missing reset token. Please request a new reset link.');
      return;
    }
    if (newPassword.length < 8) {
      setState(() => _error = 'Use at least 8 characters for your new password.');
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() {
      _loading = true;
      _error   = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      await api.confirmarReset(
        token:        widget.token,
        passwordNuevo: newPassword,
      );
      if (mounted) _showSuccessDialog();
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['detail'] as String?;
      if (mounted) {
        setState(() {
          _error = msg ?? 'Could not reset password. The link may have expired. Please request a new one.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Success dialog ────────────────────────────────────────────────────────

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.08),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 52,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'PASSWORD UPDATED',
                style: GoogleFonts.epilogue(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your password has been\nreset successfully.',
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You can now log in with your new password.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.go('/login');
                  },
                  child: Text(
                    'LOG IN NOW',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('/login'),
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
            child: Column(
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainer,
                    border:
                        Border.all(color: AppColors.surfaceContainerHighest),
                  ),
                  child: const Icon(Icons.password,
                      color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 28),

                // Title
                Text(
                  'Set New\nPassword',
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
                  'Create a strong, new password to secure your Nocturnal account.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                // Token missing warning
                if (widget.token.isEmpty) ...[
                  const SizedBox(height: 20),
                  _warningBanner(
                    'Missing reset token. Please tap the button in your email again, or request a new reset link.',
                    isError: true,
                  ),
                ],

                // Error banner
                if (_error != null && widget.token.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _warningBanner(_error!),
                ],

                const SizedBox(height: 42),

                // New password
                _label('NEW PASSWORD'),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordCtrl,
                  obscureText: _obscureNew,
                  style: GoogleFonts.manrope(
                      color: AppColors.onSurface, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppColors.onSurfaceVariant),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // Confirm password
                _label('CONFIRM NEW PASSWORD'),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _obscureConfirm,
                  style: GoogleFonts.manrope(
                      color: AppColors.onSurface, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Confirm new password',
                    prefixIcon: const Icon(Icons.lock_reset,
                        color: AppColors.onSurfaceVariant),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),

                // Submit button
                GradientButton(
                  text: _loading ? 'SAVING...' : 'SAVE NEW PASSWORD',
                  icon: Icons.check_circle_outline,
                  onPressed:
                      (_loading || widget.token.isEmpty) ? null : _save,
                ),

                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => context.push('/reset-password'),
                  child: Text(
                    'Request a new reset link',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _warningBanner(String message, {bool isError = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.manrope(
                  fontSize: 12, color: AppColors.error, height: 1.5),
            ),
          ),
        ],
      ),
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
