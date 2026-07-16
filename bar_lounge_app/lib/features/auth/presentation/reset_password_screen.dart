import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/providers/providers.dart';
import '../../../shared/widgets/gradient_button.dart';
import 'verify_code_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
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
      _error = null;
    });

    try {
      await ref.read(apiServiceProvider).solicitarReset(email);
      if (!mounted) return;
      context.push(
        '/verify-code',
        extra: VerifyCodeScreenArgs(
          purpose: VerifyCodePurpose.passwordReset,
          email: email,
        ),
      );
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['detail'] as String?;
      if (mounted) {
        setState(
          () => _error = msg ?? ErrorHandler.getMessage(e),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = ErrorHandler.getMessage(
            e,
            fallback: 'Something went wrong. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
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
      body: SafeArea(
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
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                ),
                child: const Icon(
                  Icons.lock_reset_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
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
                'Enter the email linked to your Nocturnal account and we will send a 6-digit code so you can reset your password in the app.',
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
              _label('EMAIL ADDRESS'),
              const SizedBox(height: 10),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'name@domain.com',
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              GradientButton(
                text: _loading ? 'SENDING...' : 'SEND RESET CODE',
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
