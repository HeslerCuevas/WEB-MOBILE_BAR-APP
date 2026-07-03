import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/account_page_scaffold.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountPageScaffold(
      title: 'Privacy & Terms',
      brandText: 'Nocturnal',
      children: [
        Text(
          'Generic privacy policy, terms, and conditions for Nocturnal app users.',
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        _legalSection('Privacy Policy', [
          'Nocturnal collects account details such as your name, email address, session status, table activity, and order history so the app can provide ordering, billing, and support features.',
          'Camera access is used only to scan table QR codes. Photo library access is used only when you choose a profile photo.',
          'Notification permissions are used to send order updates, account security notices, and venue communications you enable in settings.',
          'We do not sell personal information. Operational data may be shared with service providers that help run authentication, notifications, ordering, and payment workflows.',
        ]),
        const SizedBox(height: 18),
        _legalSection('Terms & Conditions', [
          'By using Nocturnal, you agree to provide accurate account information and to use the app only for legitimate venue ordering and account activity.',
          'Orders, bills, table assignments, and availability may be updated by venue staff and backend systems. Final charges are subject to venue confirmation.',
          'You are responsible for keeping your login credentials private and for reviewing your order before payment.',
          'Nocturnal may update these terms as the product evolves. Continued use of the app means you accept the updated terms.',
        ]),
        const SizedBox(height: 18),
        _legalSection('Contact', [
          'For privacy, account, or support questions, contact support@nocturnal.app.',
        ]),
      ],
    );
  }

  Widget _legalSection(String title, List<String> paragraphs) {
    return AccountGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          for (final paragraph in paragraphs) ...[
            Text(
              paragraph,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
                height: 1.55,
              ),
            ),
            if (paragraph != paragraphs.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
