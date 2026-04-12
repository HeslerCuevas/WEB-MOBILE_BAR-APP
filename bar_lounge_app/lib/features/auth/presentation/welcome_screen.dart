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
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=800&q=80',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.background),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.2),
                  AppColors.background.withValues(alpha: 0.7),
                  AppColors.background.withValues(alpha: 0.98),
                  AppColors.background,
                ],
                stops: const [0.0, 0.35, 0.65, 0.85],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Text(
                    'THE DIGITAL SOMMELIER',
                    style: GoogleFonts.manrope(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      letterSpacing: 5, color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('MASTER', style: GoogleFonts.epilogue(fontSize: 52, fontWeight: FontWeight.w900, color: AppColors.onSurface, height: 1.0)),
                  Text('BAR &', style: GoogleFonts.epilogue(fontSize: 52, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1.0)),
                  Text('LOUNGE', style: GoogleFonts.epilogue(fontSize: 52, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1.0)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(width: 40, height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('EST. 2024', style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 3, color: AppColors.onSurfaceVariant.withValues(alpha: 0.6))),
                    ),
                    Container(width: 40, height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ]),
                  const Spacer(flex: 3),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  else ...[
                    // ── LOGIN ──
                    GradientButton(
                      text: 'LOGIN',
                      icon: Icons.login,
                      height: 60,
                      onPressed: () => context.push('/login'),
                    ),
                    const SizedBox(height: 12),
                    // ── CREATE ACCOUNT ──
                    SizedBox(
                      width: double.infinity, height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/signup'),
                        icon: const Icon(Icons.person_add_outlined, size: 20),
                        label: Text('Create Account', style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          foregroundColor: AppColors.onSurface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ── GUEST ──
                    TextButton(
                      onPressed: () async {
                        try {
                          await ref.read(carritoDaoProvider).clearCart();
                          await ref.read(historialDaoProvider).clearAllHistory();
                          await ref.read(sesionDaoProvider).clearSessions();
                          await ref.read(apiClientProvider).clearToken();
                          await ref.read(sesionDaoProvider).createGuestSession();
                        } catch (_) {}
                        if (context.mounted) context.go('/scanner');
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('CONTINUE AS GUEST', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.onSurfaceVariant)),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 18),
                      ]),
                    ),
                  ],
                  const Spacer(),
                  Text('PRIVACY POLICY  •  TERMS OF SERVICE',
                      style: GoogleFonts.manrope(fontSize: 10, letterSpacing: 1, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4))),
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
