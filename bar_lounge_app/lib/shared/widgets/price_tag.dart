import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';

class PriceTag extends StatelessWidget {
  final double amount;
  final bool isDiscounted;
  final bool isStrikethrough;
  final double fontSize;
  final int decimals;

  const PriceTag({
    super.key,
    required this.amount,
    this.isDiscounted = false,
    this.isStrikethrough = false,
    this.fontSize = 17,
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = isStrikethrough
        ? AppColors.onSurfaceVariant.withValues(alpha: 0.45)
        : isDiscounted
            ? AppColors.secondary
            : AppColors.secondary;

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Transform.translate(
              offset: const Offset(0, 2),
              child: Text(
                kMoneda,
                style: GoogleFonts.manrope(
                  fontSize: isStrikethrough ? (fontSize * 0.5) : (fontSize * 0.6),
                  fontWeight: FontWeight.w700,
                  color: color.withValues(alpha: isStrikethrough ? 1.0 : 0.8),
                  decoration: isStrikethrough ? TextDecoration.lineThrough : null,
                  decorationColor: isStrikethrough ? color : null,
                ),
              ),
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 2)),
          TextSpan(
            text: '\$${amount.toStringAsFixed(decimals)}',
            style: GoogleFonts.epilogue(
              fontSize: isStrikethrough ? (fontSize * 0.7) : fontSize,
              fontWeight: isStrikethrough ? FontWeight.w500 : FontWeight.w800,
              color: color,
              decoration: isStrikethrough ? TextDecoration.lineThrough : null,
              decorationColor: isStrikethrough ? color : null,
            ),
          ),
        ],
      ),
    );
  }
}
