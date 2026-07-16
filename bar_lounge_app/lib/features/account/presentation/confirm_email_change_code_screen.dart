import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/providers/providers.dart';
import '../../../shared/widgets/gradient_button.dart';
import 'widgets/account_page_scaffold.dart';

class ConfirmEmailChangeCodeArgs {
  final String nuevoEmail;

  const ConfirmEmailChangeCodeArgs({required this.nuevoEmail});
}

class ConfirmEmailChangeCodeScreen extends ConsumerStatefulWidget {
  final ConfirmEmailChangeCodeArgs args;

  const ConfirmEmailChangeCodeScreen({super.key, required this.args});

  @override
  ConsumerState<ConfirmEmailChangeCodeScreen> createState() =>
      _ConfirmEmailChangeCodeScreenState();
}

class _ConfirmEmailChangeCodeScreenState
    extends ConsumerState<ConfirmEmailChangeCodeScreen> {
  final _currentControllers = List.generate(6, (_) => TextEditingController());
  final _newControllers = List.generate(6, (_) => TextEditingController());
  final _currentFocusNodes = List.generate(6, (_) => FocusNode());
  final _newFocusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in _currentControllers) {
      controller.dispose();
    }
    for (final controller in _newControllers) {
      controller.dispose();
    }
    for (final node in _currentFocusNodes) {
      node.dispose();
    }
    for (final node in _newFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(
    String value,
    int index,
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '').split('');
      for (var i = 0; i < controllers.length; i++) {
        controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final nextIndex =
          digits.length >= focusNodes.length ? focusNodes.length - 1 : digits.length;
      focusNodes[nextIndex].requestFocus();
      controllers[nextIndex].selection = TextSelection.fromPosition(
        TextPosition(offset: controllers[nextIndex].text.length),
      );
      return;
    }

    if (value.isNotEmpty && index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
      return;
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
      controllers[index - 1].selection = TextSelection.fromPosition(
        TextPosition(offset: controllers[index - 1].text.length),
      );
    }
  }

  KeyEventResult _handleKeyEvent(
    KeyEvent event,
    int index,
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.backspace ||
        index == 0 ||
        controllers[index].text.isNotEmpty) {
      return KeyEventResult.ignored;
    }

    controllers[index - 1].clear();
    focusNodes[index - 1].requestFocus();
    return KeyEventResult.handled;
  }

  Future<void> _submit() async {
    final codigoActual = _currentControllers.map((c) => c.text).join();
    final codigoNuevo = _newControllers.map((c) => c.text).join();
    if (codigoActual.length != 6 || codigoNuevo.length != 6) {
      setState(() => _error = 'Enter both 6-digit codes to continue.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(apiServiceProvider).confirmarCambioEmailOtp(
            codigoActual: codigoActual,
            codigoNuevo: codigoNuevo,
          );
      await ref.read(sesionDaoProvider).updateEmail(
            widget.args.nuevoEmail,
            emailVerificado: true,
          );
      if (!mounted) return;
      // This page was pushed from the profile page. Popping restores that
      // existing page (which observes the updated session) without replacing
      // the shell while its inherited widgets are still being disposed.
      context.pop();
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _error = ErrorHandler.getMessage(
              e,
              fallback: 'Could not confirm the email change.',
            ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = ErrorHandler.getMessage(
              e,
              fallback: 'Could not confirm the email change.',
            ));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final topSpacing = screenHeight > 780 ? 36.0 : 18.0;
    final bottomSpacing = screenHeight > 780 ? 56.0 : 24.0;

    return AccountPageScaffold(
      title: 'Confirm Email Change',
      brandText: normalizeBrandText(),
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 120),
      children: [
        SizedBox(height: topSpacing),
        AccountGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure confirmation required',
                          style: GoogleFonts.epilogue(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'We need both codes to confirm this email change and protect your account.',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _codeSection(
                label: 'CURRENT EMAIL CODE',
                helper: 'Code sent to your current email address',
                controllers: _currentControllers,
                focusNodes: _currentFocusNodes,
              ),
              const SizedBox(height: 28),
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
              const SizedBox(height: 28),
              _codeSection(
                label: 'NEW EMAIL CODE',
                helper: widget.args.nuevoEmail,
                controllers: _newControllers,
                focusNodes: _newFocusNodes,
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.error,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 32),
        GradientButton(
          text: _loading ? 'CONFIRMING...' : 'CONFIRM EMAIL CHANGE',
          onPressed: _loading ? null : _submit,
        ),
        SizedBox(height: bottomSpacing),
      ],
    );
  }

  Widget _codeSection({
    required String label,
    required String helper,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        const SizedBox(height: 6),
        Text(
          helper,
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => _codeBox(index, controllers, focusNodes),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
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

  Widget _codeBox(
    int index,
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    return SizedBox(
      width: 48,
      height: 66,
      child: Focus(
        onKeyEvent: (_, event) =>
            _handleKeyEvent(event, index, controllers, focusNodes),
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction:
              index == controllers.length - 1
                  ? TextInputAction.done
                  : TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (value) =>
              _handleChanged(value, index, controllers, focusNodes),
          style: GoogleFonts.epilogue(
            fontSize: 23,
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
}
