import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/password_rules.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/providers/providers.dart';
import '../../../data/api/dto/api_models.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _terms = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  Future<void> _signup() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    if (name.length > 100) {
      setState(() => _error = 'Your name must be 100 characters or fewer.');
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      setState(() => _error = 'Please enter a valid email address (e.g. name@example.com).');
      return;
    }
    final passwordValidation = PasswordRules.validate(pass);
    if (passwordValidation != null) {
      setState(() => _error = passwordValidation);
      return;
    }
    if (!_terms) {
      setState(() => _error = 'Please accept the Terms and Conditions.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final api = ref.read(apiServiceProvider);
      await api.registro(RegistroRequest(nombre_completo: name, email: email, password_plano: pass));
      final loginResponse = await api.login(LoginRequest(email: email, password_plano: pass));
      await ref.read(historialDaoProvider).clearOrdersForClient(loginResponse.cliente_id);
      await ref.read(sesionDaoProvider).createAuthSession(
        token: loginResponse.access_token,
        nombre: loginResponse.nombre_completo,
        email: loginResponse.email,
        emailVerificado: loginResponse.email_verificado,
        clienteId: loginResponse.cliente_id,
      );
      if (mounted) context.go('/scanner');
    } on DioException catch (e) {
      final detail = (e.response?.data as Map?)?['detail'] as String?;
      if (detail != null && detail.contains('ya est') && detail.contains('registrado')) {
        setState(() => _error = 'This email address is already registered. Please log in or use a different email.');
      } else if (detail != null && detail.isNotEmpty) {
        setState(() => _error = ErrorHandler.getMessage(e));
      } else {
        setState(() => _error = 'Could not create account. Please try again.');
      }
    } catch (e) {
      setState(() => _error = ErrorHandler.getMessage(e, fallback: 'Could not create account. Please try again.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
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
                    decoration: BoxDecoration(color: AppColors.glassPanelBg, borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create your account', style: GoogleFonts.epilogue(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                        const SizedBox(height: 4),
                        Text('Join the elite circle of Master Bar & Lounge.', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
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
                        _label('FULL NAME'),
                        const SizedBox(height: 8),
                        TextField(controller: _nameCtrl, maxLength: 100, style: GoogleFonts.manrope(color: AppColors.onSurface), decoration: const InputDecoration(hintText: 'Julian Sterling', prefixIcon: Icon(Icons.person_outline, color: AppColors.outline))),
                        const SizedBox(height: 20),
                        _label('EMAIL ADDRESS'),
                        const SizedBox(height: 8),
                        TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, style: GoogleFonts.manrope(color: AppColors.onSurface), decoration: const InputDecoration(hintText: 'sterling@nocturnal.com', prefixIcon: Icon(Icons.alternate_email, color: AppColors.outline))),
                        const SizedBox(height: 20),
                        _label('PASSWORD'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: GoogleFonts.manrope(color: AppColors.onSurface),
                          decoration: InputDecoration(
                            hintText: '••••••••••',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.outline),
                            suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.outline), onPressed: () => setState(() => _obscure = !_obscure)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(width: 24, height: 24, child: Checkbox(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false), activeColor: AppColors.primaryContainer, side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
                          const SizedBox(width: 12),
                          Expanded(child: Text.rich(TextSpan(text: 'I agree to the ', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant), children: [
                            WidgetSpan(alignment: PlaceholderAlignment.baseline, baseline: TextBaseline.alphabetic, child: GestureDetector(onTap: () => context.push('/legal'), child: Text('Terms and Conditions', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)))),
                            const TextSpan(text: ' and the '),
                            WidgetSpan(alignment: PlaceholderAlignment.baseline, baseline: TextBaseline.alphabetic, child: GestureDetector(onTap: () => context.push('/legal'), child: Text('Privacy Policy', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)))),
                            const TextSpan(text: '.'),
                          ]))),
                        ]),
                        const SizedBox(height: 24),
                        GradientButton(text: _loading ? 'CREATING...' : 'CREATE ACCOUNT', onPressed: _loading ? null : _signup),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Already have an account?  ', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant)),
                GestureDetector(onTap: () => context.push('/login'), child: Text('Login', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.onSurfaceVariant));
}
