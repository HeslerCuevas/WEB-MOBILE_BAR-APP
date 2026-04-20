import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
class ResetLinkSentScreen extends StatelessWidget {
  const ResetLinkSentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLow,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'THE NOCTURNAL',
          style: GoogleFonts.epilogue(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.1),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: AppColors.amberGlow,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mark_email_read_outlined,
                                size: 40,
                                color: AppColors.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'Check your inbox',
                              style: GoogleFonts.epilogue(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text.rich(
                              TextSpan(
                                text: "We've sent a password reset link to your registered email. Please follow the instructions to secure your ",
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.6,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Master Bar & Lounge',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' account.'),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            GradientButton(
                              text: 'Open Email App',
                              onPressed: () {},
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () => context.go('/login'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surfaceContainerHigh,
                                  foregroundColor: AppColors.onSurfaceVariant,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppColors.outlineVariant.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Back to Login',
                                  style: GoogleFonts.epilogue(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Container(
                              height: 1,
                              color: AppColors.outlineVariant.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive the email?  ",
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  'Resend Link',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppColors.secondary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.security, color: AppColors.secondary, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'End-to-End\nEncryption',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer, color: AppColors.secondary, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Link expires in\n15m',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
