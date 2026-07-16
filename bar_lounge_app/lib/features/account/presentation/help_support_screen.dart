import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/account_page_scaffold.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  static const _faqs = [
    (
      'How do I split a bill with friends?',
      'Ask your server to split the active table bill before checkout. In-app split controls can be added when the payment flow is connected.',
    ),
    (
      'What is the dress code policy?',
      'Smart evening wear is recommended for the lounge. Venue staff can confirm special-event requirements.',
    ),
    (
      'Can I reserve a specific table?',
      'Table requests are handled by the concierge team and depend on availability for the night.',
    ),
    (
      'Why do I need to scan a QR code?',
      'The QR code links your app session to the correct table so orders and bills stay attached to your visit.',
    ),
    (
      'Can I change tables after scanning?',
      'Yes. Ask venue staff to confirm the move, then scan the new table code or enter the new table number manually.',
    ),
    (
      'Where can I see my previous orders?',
      'Open Account and choose Order History to review past sessions and receipts saved on this device.',
    ),
    (
      'Why did my order status change?',
      'Order and payment statuses can update from the venue system, staff actions, or payment confirmation notifications.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AccountPageScaffold(
      title: 'Help & Support',
      brandText: normalizeBrandText(),
      children: [
        Text(
          'How can our digital sommelier assist you tonight?',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Frequently Asked Questions',
          style: GoogleFonts.epilogue(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < _faqs.length; i++) ...[
          _faqTile(i, _faqs[i].$1, _faqs[i].$2),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 18),
        AccountGlassCard(
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: const Icon(
                  Icons.mail_outline,
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
                      'Email Support',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'support@nocturnal.app',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.local_bar,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                size: 26,
              ),
              const SizedBox(height: 12),
              Text(
                'NOCTURNAL',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Version 2.4.1',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.42),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _faqTile(int index, String question, String answer) {
    final expanded = _expandedIndex == index;
    return AccountGlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap:
                () => setState(() => _expandedIndex = expanded ? null : index),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                answer,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}
