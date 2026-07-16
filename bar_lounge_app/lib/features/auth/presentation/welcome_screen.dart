import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/providers/providers.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    try {
      final token = await ref.read(apiClientProvider).getToken();
      if (token != null && token.isNotEmpty) {
        ref.read(apiServiceProvider).syncFCMToken();
        if (mounted) context.go('/menu');
        return;
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.surfaceContainerLow,
                  AppColors.background,
                ],
              ),
            ),
          ),
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.09),
              ),
            ),
          ),
          Positioned(
            bottom: 110,
            left: -180,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  Container(
                    width: 126,
                    height: 126,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          blurRadius: 32,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'LOGO_NORCTURAL_BAR.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'NOCTURNAL ',
                            style: GoogleFonts.epilogue(
                              fontSize: 45,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onSurface,
                              height: 1,
                              letterSpacing: -1.5,
                            ),
                          ),
                          TextSpan(
                            text: 'BAR',
                            style: GoogleFonts.epilogue(
                              fontSize: 45,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              height: 1,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 1,
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'EST. 2024',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            letterSpacing: 3,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 1,
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  else ...[
                    GradientButton(
                      text: 'LOGIN',
                      icon: Icons.login,
                      height: 60,
                      onPressed: () => context.push('/login'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/signup'),
                        icon: const Icon(Icons.person_add_outlined, size: 20),
                        label: Text(
                          'Create Account',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          foregroundColor: AppColors.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        try {
                          await ref.read(carritoDaoProvider).clearCart();
                          await ref
                              .read(historialDaoProvider)
                              .clearAllHistory();
                          await ref.read(sesionDaoProvider).clearSessions();
                          await ref.read(apiClientProvider).clearToken();
                          await ref
                              .read(sesionDaoProvider)
                              .createGuestSession();
                        } catch (_) {}
                        if (context.mounted) context.go('/scanner');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CONTINUE AS GUEST',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.onSurfaceVariant,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    'PRIVACY POLICY  •  TERMS OF SERVICE',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
