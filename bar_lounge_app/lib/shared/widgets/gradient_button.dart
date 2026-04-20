import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final Gradient? gradient;
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.height = 56,
    this.borderRadius = 12,
    this.gradient,
  });
  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: isDisabled ? null : (gradient ?? AppColors.amberGlow),
        color: isDisabled ? AppColors.surfaceContainerHigh : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDisabled ? null : AppColors.ctaShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDisabled ? AppColors.onSurfaceVariant.withValues(alpha: 0.5) : AppColors.onPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: isDisabled ? AppColors.onSurfaceVariant.withValues(alpha: 0.5) : AppColors.onPrimary, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
