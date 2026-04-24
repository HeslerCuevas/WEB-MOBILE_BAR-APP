import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/providers/providers.dart';
import '../../../data/api/dto/api_models.dart';
class LoginScreen extends ConsumerStatefulWidget {
  final String? errorMessage;
  const LoginScreen({super.key, this.errorMessage});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _error = widget.errorMessage;
  }
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.login(LoginRequest(email: email, password_plano: pass));
      await ref.read(sesionDaoProvider).createAuthSession(
        token: response.access_token,
        nombre: response.nombre_completo,
        clienteId: response.cliente_id,
      );
      if (mounted) context.go('/scanner');
    } on DioException catch (error) {
      if (error.response != null &&
          (error.response?.statusCode == 400 ||
              error.response?.statusCode == 401)) {
        setState(() => _error = 'Email or password is incorrect.');
        return;
      }
      try {
        await ref.read(sesionDaoProvider).createAuthSession(
          token: 'offline_token',
          nombre: email.split('@').first,
          clienteId: null,
        );
        if (mounted) context.go('/scanner');
      } catch (_) {
        setState(() => _error = 'Login failed. Please try again.');
      }
    } catch (_) {
      setState(() => _error = 'Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(top: -80, right: -80, child: Container(width: 280, height: 280,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.07)))),
          Positioned(bottom: -100, left: -80, child: Container(width: 240, height: 240,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.tertiary.withValues(alpha: 0.05)))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 32),
                const SizedBox(height: 8),
                Text('NOCTURNAL', style: GoogleFonts.epilogue(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 2)),
                const SizedBox(height: 4),
                Text('MASTER BAR & LOUNGE', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 4, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 36),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.glassPanelBg,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Welcome back', style: GoogleFonts.epilogue(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                        const SizedBox(height: 4),
                        Text('Enter your credentials to access the lounge.', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: Row(children: [
                              const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_error!, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.error))),
                            ]),
                          ),
                        ],
                        const SizedBox(height: 24),
                        _label('EMAIL ADDRESS'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.manrope(color: AppColors.onSurface),
                          decoration: InputDecoration(hintText: 'name@domain.com', prefixIcon: const Icon(Icons.alternate_email, color: AppColors.outline)),
                        ),
                        const SizedBox(height: 20),
                        _label('PASSWORD'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: GoogleFonts.manrope(color: AppColors.onSurface),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.outline),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        GradientButton(
                          text: _loading ? 'ENTERING LOUNGE...' : 'Login to Lounge',
                          onPressed: _loading ? null : _login,
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account?  ", style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant)),
                  GestureDetector(
                    onTap: () => context.push('/signup'),
                    child: Text('Request Access', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ]),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
  Widget _label(String t) => Text(t, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.onSurfaceVariant));
}
