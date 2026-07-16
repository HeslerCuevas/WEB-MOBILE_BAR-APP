import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '').split('');
      for (var i = 0; i < digits.length && i < _controllers.length; i++) {
        _controllers[i].text = digits[i];
      }
      final nextIndex = digits.length.clamp(0, _focusNodes.length - 1);
      _focusNodes[nextIndex].requestFocus();
      return;
    }

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _verify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter the 6-digit verification code.',
            style: GoogleFonts.manrope(),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Identity verified.', style: GoogleFonts.manrope()),
        backgroundColor: AppColors.surfaceContainerHigh,
      ),
    );
    context.go('/login');
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
              context.go('/reset-password');
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
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.18),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Enter Verification Code',
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "We've sent a 6-digit access code to your registered email address.",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  height: 1.45,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'Enter the code exactly as shown in the email to continue resetting your password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _codeBox(index)),
              ),
              const SizedBox(height: 34),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'A new code was sent.',
                            style: GoogleFonts.manrope(),
                          ),
                          backgroundColor: AppColors.surfaceContainerHigh,
                        ),
                      );
                    },
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
              const SizedBox(height: 20),
              GradientButton(text: 'VERIFY IDENTITY', onPressed: _verify),
            ],
          ),
        ),
          ),
        ),
      ),
    );
  }

  Widget _codeBox(int index) {
    return SizedBox(
      width: 48,
      height: 64,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        onChanged: (value) => _handleChanged(value, index),
        onTap:
            () =>
                _controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controllers[index].text.length,
                ),
        onSubmitted: (_) {
          if (index < _focusNodes.length - 1) {
            _focusNodes[index + 1].requestFocus();
          }
        },
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
              color: AppColors.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
