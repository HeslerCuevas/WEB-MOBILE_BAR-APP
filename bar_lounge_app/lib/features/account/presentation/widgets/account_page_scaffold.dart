import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class AccountPageScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String brandText;
  final EdgeInsetsGeometry padding;
  final TextAlign titleTextAlign;

  const AccountPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.brandText = 'NOCTURNAL',
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 120),
    this.titleTextAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/account');
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      brandText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.epilogue(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        title,
                        textAlign: titleTextAlign,
                        style: GoogleFonts.epilogue(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;

  const AccountGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceContainerLow.withValues(alpha: 0.92),
            AppColors.surfaceContainerLow.withValues(alpha: 0.62),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

Widget accountSectionLabel(String text) {
  return Text(
    text,
    style: GoogleFonts.manrope(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.6,
      color: AppColors.onSurfaceVariant,
    ),
  );
}

String normalizeBrandText([String text = 'NOCTURNAL']) => text.toUpperCase();
