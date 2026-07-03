import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/account_page_scaffold.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountPageScaffold(
      title: 'Protect Your Experience',
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
          subtitle: 'Last updated 3 months ago',
          trailing: Icons.chevron_right,
          onTap: () => context.push('/reset-password'),
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
        AccountGlassCard(
          onTap: () => _showDeleteDialog(context),
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

  Future<void> _showDeleteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: AppColors.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Delete account?',
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            content: Text(
              'This is a placeholder until account deletion is connected to the API.',
              style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Close',
                  style: GoogleFonts.manrope(color: AppColors.primary),
                ),
              ),
            ],
          ),
    );
  }
}
