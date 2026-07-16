import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/password_rules.dart';
import '../../../data/providers/providers.dart';
import '../../../shared/widgets/gradient_button.dart';

enum VerifyCodePurpose { emailVerification, passwordReset }

class VerifyCodeScreenArgs {
  final VerifyCodePurpose purpose;
  final String email;

  const VerifyCodeScreenArgs({
    required this.purpose,
    required this.email,
  });
}

class VerifyCodeScreen extends ConsumerStatefulWidget {
  final VerifyCodeScreenArgs args;

  const VerifyCodeScreen({super.key, required this.args});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _error;

  bool get _isPasswordReset =>
      widget.args.purpose == VerifyCodePurpose.passwordReset;

  String get _successNoticeText => _isPasswordReset
      ? 'Password updated. You can log in now.'
      : 'Email verified successfully.';

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '').split('');
      for (var i = 0; i < _controllers.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final nextIndex = digits.length >= _focusNodes.length
          ? _focusNodes.length - 1
          : digits.length;
      _focusNodes[nextIndex].requestFocus();
      _controllers[nextIndex].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[nextIndex].text.length),
      );
      return;
    }

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
      return;
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index - 1].text.length),
      );
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event, int index) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.backspace ||
        index == 0 ||
        _controllers[index].text.isNotEmpty) {
      return KeyEventResult.ignored;
    }

    _controllers[index - 1].clear();
    _focusNodes[index - 1].requestFocus();
    return KeyEventResult.handled;
  }

  void _showBottomNotice(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.info_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor:
            isError ? AppColors.surfaceContainerHigh : AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 88),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submit() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      setState(() => _error = 'Enter the full 6-digit code.');
      return;
    }

    if (_isPasswordReset) {
      final password = _passwordCtrl.text.trim();
      final confirm = _confirmPasswordCtrl.text.trim();
      final passwordValidation = PasswordRules.validate(password);
      if (passwordValidation != null) {
        setState(() => _error = passwordValidation);
        return;
      }
      if (password != confirm) {
        setState(() => _error = 'Passwords do not match.');
        return;
      }
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      if (_isPasswordReset) {
        await api.confirmarResetOtp(
          email: widget.args.email,
          codigo: code,
          passwordNuevo: _passwordCtrl.text.trim(),
          passwordNuevoConfirmacion: _confirmPasswordCtrl.text.trim(),
        );
        if (!mounted) return;
        _showBottomNotice(_successNoticeText);
        context.go('/login');
        return;
      }

      await api.verificarEmail(code);
      await ref.read(sesionDaoProvider).updateEmailVerification(true);
      if (!mounted) return;
      _showBottomNotice(_successNoticeText);
      context.go('/account');
    } on DioException catch (e) {
      if (mounted) {
        final message = ErrorHandler.getMessage(
          e,
          fallback: 'Could not verify the code. Please try again.',
        );
        _showBottomNotice(message, isError: true);
      }
    } catch (e) {
      if (mounted) {
        final message = ErrorHandler.getMessage(
          e,
          fallback: 'Could not verify the code. Please try again.',
        );
        _showBottomNotice(message, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      if (_isPasswordReset) {
        await api.solicitarReset(widget.args.email);
      } else {
        await api.solicitarVerificacionEmail();
      }
      if (!mounted) return;
      _showBottomNotice('A new verification code was sent to your email.');
    } on DioException catch (e) {
      if (mounted) {
        final message = ErrorHandler.getMessage(
          e,
          fallback: 'Could not resend the code. Please try again.',
        );
        _showBottomNotice(message, isError: true);
      }
    } catch (e) {
      if (mounted) {
        final message = ErrorHandler.getMessage(
          e,
          fallback: 'Could not resend the code. Please try again.',
        );
        _showBottomNotice(message, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isPasswordReset ? 'Reset Password' : 'Verify Your Email';
    final buttonText = _isPasswordReset ? 'UPDATE PASSWORD' : 'VERIFY EMAIL';
    final subtitle = _isPasswordReset
        ? 'We sent a 6-digit code to ${widget.args.email}. Enter it below and choose your new password.'
        : 'We sent a 6-digit code to ${widget.args.email}. Enter it below to secure your account.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(_isPasswordReset ? '/reset-password' : '/account');
            }
          },
        ),
        title: Text(
          'NOCTURNAL',
          style: GoogleFonts.epilogue(
            fontSize: 18,
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
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
          child: Column(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, _codeBox),
              ),
              if (_isPasswordReset) ...[
                const SizedBox(height: 28),
                _label('NEW PASSWORD'),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurface,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Create a strong password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.onSurfaceVariant,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _label('CONFIRM PASSWORD'),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _obscureConfirmPassword,
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurface,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Repeat your new password',
                    prefixIcon: const Icon(
                      Icons.lock_reset_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => _obscureConfirmPassword =
                            !_obscureConfirmPassword,
                      ),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: _loading ? null : _resendCode,
                    child: Text(
                      'RESEND',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GradientButton(
                text: _loading ? 'VERIFYING...' : buttonText,
                onPressed: _loading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _codeBox(int index) {
    return SizedBox(
      width: 48,
      height: 64,
      child: Focus(
        onKeyEvent: (node, event) => _handleKeyEvent(node, event, index),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction:
              index == _controllers.length - 1
                  ? TextInputAction.done
                  : TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (value) => _handleChanged(value, index),
          style: GoogleFonts.epilogue(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '0',
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: AppColors.surfaceContainer,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
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
