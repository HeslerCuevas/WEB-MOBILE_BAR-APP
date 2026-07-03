import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscureNew = true;
  String? _error;

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _savePassword() {
    final newPassword = _newPasswordCtrl.text.trim();
    final confirmPassword = _confirmPasswordCtrl.text.trim();
    if (newPassword.length < 8) {
      setState(
        () => _error = 'Use at least 8 characters for your new password.',
      );
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    context.push('/verify-code');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainer,
                    border: Border.all(
                      color: AppColors.surfaceContainerHighest,
                    ),
                  ),
                  child: const Icon(
                    Icons.password,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Reset\nPassword',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.epilogue(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Create a strong, new password to secure your digital sommelier access.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    height: 1.45,
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
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 18,
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
                const SizedBox(height: 42),
                _label('NEW PASSWORD'),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordCtrl,
                  obscureText: _obscureNew,
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurface,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.onSurfaceVariant,
                    ),
                    suffixIcon: IconButton(
                      onPressed:
                          () => setState(() => _obscureNew = !_obscureNew),
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
                _label('CONFIRM NEW PASSWORD'),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordCtrl,
                  obscureText: true,
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurface,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Confirm new password',
                    prefixIcon: Icon(
                      Icons.lock_reset,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                GradientButton(
                  text: 'SAVE PASSWORD',
                  icon: Icons.check_circle_outline,
                  onPressed: _savePassword,
                ),
              ],
            ),
          ),
        ),
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
