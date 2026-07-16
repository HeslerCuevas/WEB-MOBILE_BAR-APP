import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/password_rules.dart';
import '../../../data/providers/providers.dart';
import '../../../shared/widgets/gradient_button.dart';
import 'widgets/account_page_scaffold.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl     = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew     = true;
  bool _obscureConfirm = true;
  bool _loading        = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final current = _currentCtrl.text.trim();
    final newPass  = _newCtrl.text.trim();
    final confirm  = _confirmCtrl.text.trim();

    // ── Client-side validation ────────────────────────────────────────────────
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      setState(() { _error = 'Please fill in all fields.'; _success = null; });
      return;
    }
    if (newPass != confirm) {
      setState(() { _error = 'New passwords do not match.'; _success = null; });
      return;
    }
    final passwordValidation = PasswordRules.validate(newPass);
    if (passwordValidation != null) {
      setState(() { _error = passwordValidation; _success = null; });
      return;
    }
    if (newPass == current) {
      setState(() { _error = 'New password must be different from your current password.'; _success = null; });
      return;
    }

    setState(() { _loading = true; _error = null; _success = null; });

    try {
      await ref.read(apiServiceProvider).cambiarPassword(
        passwordActual: current,
        passwordNuevo: newPass,
        passwordNuevoConfirmacion: confirm,
      );
      if (mounted) {
        setState(() {
          _success = 'Password changed successfully! A confirmation email has been sent.';
          _currentCtrl.clear();
          _newCtrl.clear();
          _confirmCtrl.clear();
        });
      }
    } on DioException catch (e) {
      setState(() {
        _error = ErrorHandler.getMessage(
          e,
          fallback: 'Could not change password. Please try again.',
        );
      });
    } catch (e) {
      setState(() {
        _error = ErrorHandler.getMessage(
          e,
          fallback: 'Could not change password. Please try again.',
        );
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AccountPageScaffold(
      title: 'Change Password',
      brandText: normalizeBrandText(),
      children: [
        Text(
          'Enter your current password and choose a new one. '
          'You\'ll receive a security notification email after the change.',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // ── Status messages ─────────────────────────────────────────────────
        if (_error != null) ...[
          _statusBanner(
            message: _error!,
            color: AppColors.error,
            icon: Icons.error_outline,
          ),
          const SizedBox(height: 16),
        ],
        if (_success != null) ...[
          _statusBanner(
            message: _success!,
            color: const Color(0xFF4CAF50),
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 16),
        ],

        // ── Form ────────────────────────────────────────────────────────────
        AccountGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              accountSectionLabel('CURRENT PASSWORD'),
              const SizedBox(height: 10),
              _passwordField(
                controller: _currentCtrl,
                hint: '••••••••',
                obscure: _obscureCurrent,
                onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
              ),
              const SizedBox(height: 18),
              accountSectionLabel('NEW PASSWORD'),
              const SizedBox(height: 10),
              _passwordField(
                controller: _newCtrl,
                hint: '8+ chars, upper, lower, number',
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 18),
              accountSectionLabel('CONFIRM NEW PASSWORD'),
              const SizedBox(height: 10),
              _passwordField(
                controller: _confirmCtrl,
                hint: 'Repeat new password',
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GradientButton(
          text: _loading ? 'UPDATING...' : 'CHANGE PASSWORD',
          onPressed: _loading ? null : _changePassword,
        ),
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.manrope(color: AppColors.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.onSurfaceVariant),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.outline,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _statusBanner({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.manrope(fontSize: 13, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
