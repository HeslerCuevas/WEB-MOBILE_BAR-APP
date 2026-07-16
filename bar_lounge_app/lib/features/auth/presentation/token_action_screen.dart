import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../shared/widgets/gradient_button.dart';

class TokenActionScreen extends ConsumerStatefulWidget {
  final String action;
  final String token;
  final String? tipo;

  const TokenActionScreen({
    super.key,
    required this.action,
    required this.token,
    this.tipo,
  });

  @override
  ConsumerState<TokenActionScreen> createState() => _TokenActionScreenState();
}

class _TokenActionScreenState extends ConsumerState<TokenActionScreen> {
  bool _loading = true;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    if (widget.token.isEmpty) {
      _error = 'Invalid or missing link.';
      _loading = false;
    } else {
      _processAction();
    }
  }

  Future<void> _processAction() async {
    try {
      final api = ref.read(apiServiceProvider);

      if (widget.action == 'confirm-email-change') {
        if (widget.tipo == null) throw Exception('Missing tipo');
        final res = await api.confirmarCambioEmail(
          token: widget.token,
          tipo: widget.tipo!,
        );
        _success = res.mensaje;
        
        // If it was the 'new' email confirmation, we might want to log them out
        // to force a fresh login with the new email. For simplicity, just show the success message.
      } else if (widget.action == 'confirm-delete') {
        final res = await api.confirmarEliminacion(widget.token);
        _success = res.mensaje;
        // Log them out automatically
        await ref.read(sesionDaoProvider).clearSessions();
      } else if (widget.action == 'reactivate') {
        final res = await api.confirmarReactivacion(widget.token);
        _success = res.mensaje;
      } else {
        throw Exception('Unknown action');
      }
    } on DioException catch (e) {
      final detail = (e.response?.data as Map?)?['detail'] as String?;
      _error = detail ?? 'The link has expired or is invalid.';
    } catch (_) {
      _error = 'An error occurred while processing the link.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_loading) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verifying...',
                    style: GoogleFonts.epilogue(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ] else if (_error != null) ...[
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verification Failed',
                    style: GoogleFonts.epilogue(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    text: 'BACK TO APP',
                    onPressed: () {
                      if (GoRouter.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go('/login');
                      }
                    },
                  ),
                ] else if (_success != null) ...[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF4CAF50),
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Success',
                    style: GoogleFonts.epilogue(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _success!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    text: widget.action == 'reactivate' ? 'LOGIN NOW' : 'CONTINUE',
                    onPressed: () {
                      if (widget.action == 'confirm-delete' || widget.action == 'reactivate') {
                        context.go('/login');
                      } else {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                        } else {
                          context.go('/login');
                        }
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
