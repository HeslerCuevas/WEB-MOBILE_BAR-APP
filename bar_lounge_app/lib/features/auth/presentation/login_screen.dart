import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/utils/error_handler.dart';
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
  final _passCtrl  = TextEditingController();
  bool _obscure     = true;
  bool _loading     = false;
  bool _isInactive  = false;   // true when the account exists but is deactivated
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
    final pass  = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    setState(() {
      _loading    = true;
      _error      = null;
      _isInactive = false;
    });
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.login(
        LoginRequest(email: email, password_plano: pass),
      );
      await ref
          .read(sesionDaoProvider)
          .createAuthSession(
            token: response.access_token,
            nombre: response.nombre_completo,
            email: email,
            clienteId: response.cliente_id,
          );
      if (mounted) context.go('/scanner');
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final detail = (error.response?.data as Map?)?['detail'] as String? ?? '';

      if (statusCode == 403 && detail.contains('CUENTA_INACTIVA')) {
        // Inactive account — offer reactivation flow
        setState(() {
          _isInactive = true;
          _error = 'Your account is currently inactive.';
        });
        return;
      }

      if (statusCode == 400 || statusCode == 401) {
        setState(() => _error = 'Email or password is incorrect.');
        return;
      }

      // CORE offline — try local session
      try {
        await ref
            .read(sesionDaoProvider)
            .createAuthSession(
              token: 'offline_token',
              nombre: email.split('@').first,
              email: email,
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

  /// Sends a reactivation email and shows a confirmation snackbar.
  Future<void> _sendReactivation() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Enter your email address above, then tap Reactivate.');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(apiServiceProvider).solicitarReactivacion(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reactivation email sent! Check your inbox and tap the link.',
              style: GoogleFonts.manrope(fontSize: 13),
            ),
            backgroundColor: AppColors.surfaceContainerHigh,
            duration: const Duration(seconds: 5),
          ),
        );
        setState(() {
          _isInactive = false;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not send reactivation email. Please try again.');
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const SizedBox(height: 8),
                  Text(
                    'NOCTURNAL',
                    style: GoogleFonts.epilogue(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MASTER BAR & LOUNGE',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
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
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: GoogleFonts.epilogue(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Enter your credentials to access the lounge.',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: AppColors.error,
                                          size: 16,
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
                                    // Reactivation button shown only when account is inactive
                                    if (_isInactive) ...[
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.primary,
                                            side: const BorderSide(color: AppColors.primary),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                          ),
                                          icon: const Icon(Icons.restore, size: 16),
                                          label: Text(
                                            _loading ? 'Sending...' : 'Reactivate Account',
                                            style: GoogleFonts.manrope(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          onPressed: _loading ? null : _sendReactivation,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            _label('EMAIL ADDRESS'),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.manrope(
                                color: AppColors.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'name@domain.com',
                                prefixIcon: const Icon(
                                  Icons.alternate_email,
                                  color: AppColors.outline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _label('PASSWORD'),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passCtrl,
                              obscureText: _obscure,
                              style: GoogleFonts.manrope(
                                color: AppColors.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.outline,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.outline,
                                  ),
                                  onPressed:
                                      () =>
                                          setState(() => _obscure = !_obscure),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed:
                                    () => context.push('/reset-password'),
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            GradientButton(
                              text:
                                  _loading
                                      ? 'ENTERING LOUNGE...'
                                      : 'Login to Lounge',
                              onPressed: _loading ? null : _login,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/signup'),
                        child: Text(
                          'Request Access',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Text(
    t,
    style: GoogleFonts.manrope(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
      color: AppColors.onSurfaceVariant,
    ),
  );
}
