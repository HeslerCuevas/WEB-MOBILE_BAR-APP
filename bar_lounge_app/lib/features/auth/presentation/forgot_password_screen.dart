import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 20),
            Text('Lost in the', style: GoogleFonts.epilogue(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
            Text('Shadows?', style: GoogleFonts.epilogue(fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: AppColors.primary)),
            const SizedBox(height: 12),
            Text('Enter your email to receive a reset link.', textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 15, color: AppColors.onSurfaceVariant, height: 1.5)),
            const SizedBox(height: 36),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.glassCardBg, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('MEMBER EMAIL', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.manrope(color: AppColors.onSurface),
                      decoration: InputDecoration(hintText: 'sommelier@nocturnal.bar', prefixIcon: const Icon(Icons.mail_outline, color: AppColors.outline)),
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      text: _loading ? 'SENDING...' : 'Send Reset Link',
                      icon: Icons.send,
                      onPressed: _loading ? null : () async {
                        if (_emailCtrl.text.trim().isEmpty) return;
                        setState(() => _loading = true);
                        await Future.delayed(const Duration(milliseconds: 800));
                        if (!mounted) return;
                        setState(() => _loading = false);
                        context.push('/reset-link-sent');
                      },
                    ),
                    const SizedBox(height: 20),
                    Divider(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push('/login'),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.login, size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text('Return to Login', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
