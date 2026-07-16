import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import 'widgets/account_page_scaffold.dart';

class SecurityPrivacyScreen extends ConsumerWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountPageScaffold(
      title: 'Protect Your Experience',
      brandText: normalizeBrandText(),
      children: [
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Manage your security preferences and control how your data is used within the Nocturnal ecosystem.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        accountSectionLabel('ACCOUNT SETTINGS'),
        const SizedBox(height: 14),
        _securityAction(
          icon: Icons.key_outlined,
          title: 'Change Password',
          subtitle: 'Update your login credentials',
          trailing: Icons.chevron_right,
          // Route to the authenticated change-password screen, NOT reset-password
          onTap: () => context.push('/account/change-password'),
        ),
        const SizedBox(height: 14),
        _securityAction(
          icon: Icons.policy_outlined,
          title: 'Privacy Policy',
          subtitle: 'Review our terms and conditions',
          trailing: Icons.chevron_right,
          onTap: () => context.push('/legal'),
        ),
        const SizedBox(height: 34),
        Divider(color: Colors.white.withValues(alpha: 0.06)),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _showDeleteDialog(context, ref),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_forever_outlined, color: AppColors.error),
                const SizedBox(width: 12),
                Text(
                  'Delete Account',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _securityAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required IconData trailing,
    required VoidCallback onTap,
  }) {
    return AccountGlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(trailing, color: AppColors.primaryContainer, size: 20),
        ],
      ),
    );
  }

  /// Shows the delete-account confirmation dialog.
  /// Requires the user to enter their current password before sending the request.
  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final passwordCtrl = TextEditingController();
    bool obscure  = true;
    bool loading  = false;
    String? error;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (_, setState) => AlertDialog(
            backgroundColor: AppColors.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Delete Account?',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deleting your account will disable your access. '
                  'Your order history and transactions may be retained for legal and operational purposes.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A confirmation email will be sent. Your account will only be '
                  'deactivated after you click the link in that email.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CONFIRM WITH PASSWORD',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                StatefulBuilder(
                  builder: (_, setField) => TextField(
                    controller: passwordCtrl,
                    obscureText: obscure,
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.outline,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.outline,
                        ),
                        onPressed: () =>
                            setField(() => obscure = !obscure),
                      ),
                    ),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    error!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        passwordCtrl.dispose();
                        Navigator.of(dialogContext).pop();
                      },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                ),
              ),
              TextButton(
                onPressed: loading
                    ? null
                    : () async {
                        final pass = passwordCtrl.text.trim();
                        if (pass.isEmpty) {
                          setState(() => error = 'Enter your password to confirm.');
                          return;
                        }
                        setState(() {
                          loading = true;
                          error   = null;
                        });
                        try {
                          await ref.read(apiServiceProvider).solicitarEliminacion(
                            passwordActual: pass,
                          );
                          if (dialogContext.mounted) {
                            passwordCtrl.dispose();
                            Navigator.of(dialogContext).pop();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Confirmation email sent! Tap the link in your inbox to complete deletion.',
                                    style: GoogleFonts.manrope(fontSize: 13),
                                  ),
                                  backgroundColor: AppColors.surfaceContainerHigh,
                                  duration: const Duration(seconds: 6),
                                ),
                              );
                            }
                          }
                        } on DioException catch (e) {
                          final detail =
                              (e.response?.data as Map?)?['detail'] as String?;
                          setState(() {
                            loading = false;
                            error = (detail != null && detail.contains('incorrecta'))
                                ? 'Incorrect password. Please try again.'
                                : (detail ?? 'Could not process request. Please try again.');
                          });
                        } catch (_) {
                          setState(() {
                            loading = false;
                            error = 'Could not process request. Please try again.';
                          });
                        }
                      },
                child: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.error),
                        ),
                      )
                    : Text(
                        'Send Deletion Email',
                        style: GoogleFonts.manrope(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
