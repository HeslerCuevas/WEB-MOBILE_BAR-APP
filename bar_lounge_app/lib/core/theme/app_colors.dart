import 'package:flutter/material.dart';
class AppColors {
  AppColors._();
  static const Color background = Color(0xFF0F131C);
  static const Color surface = Color(0xFF0F131C);
  static const Color surfaceDim = Color(0xFF0F131C);
  static const Color surfaceContainerLowest = Color(0xFF0A0E17);
  static const Color surfaceContainerLow = Color(0xFF181B25);
  static const Color surfaceContainer = Color(0xFF1C1F29);
  static const Color surfaceContainerHigh = Color(0xFF262A34);
  static const Color surfaceContainerHighest = Color(0xFF31353F);
  static const Color surfaceBright = Color(0xFF353943);
  static const Color surfaceVariant = Color(0xFF31353F);
  static const Color primary = Color(0xFFFFB693);
  static const Color primaryContainer = Color(0xFFFF6B00);
  static const Color primaryFixed = Color(0xFFFFDBCC);
  static const Color primaryFixedDim = Color(0xFFFFB693);
  static const Color onPrimary = Color(0xFF561F00);
  static const Color onPrimaryContainer = Color(0xFF572000);
  static const Color onPrimaryFixed = Color(0xFF351000);
  static const Color onPrimaryFixedVariant = Color(0xFF7A3000);
  static const Color inversePrimary = Color(0xFFA04100);
  static const Color surfaceTint = Color(0xFFFFB693);
  static const Color secondary = Color(0xFFE9C349);
  static const Color secondaryContainer = Color(0xFFAF8D11);
  static const Color secondaryFixed = Color(0xFFFFE088);
  static const Color secondaryFixedDim = Color(0xFFE9C349);
  static const Color onSecondary = Color(0xFF3C2F00);
  static const Color onSecondaryContainer = Color(0xFF342800);
  static const Color onSecondaryFixed = Color(0xFF241A00);
  static const Color onSecondaryFixedVariant = Color(0xFF574500);
  static const Color tertiary = Color(0xFF00DAF8);
  static const Color tertiaryContainer = Color(0xFF00A8C0);
  static const Color tertiaryFixed = Color(0xFFA5EEFF);
  static const Color tertiaryFixedDim = Color(0xFF00DAF8);
  static const Color onTertiary = Color(0xFF00363F);
  static const Color onTertiaryContainer = Color(0xFF003740);
  static const Color onTertiaryFixed = Color(0xFF001F25);
  static const Color onTertiaryFixedVariant = Color(0xFF004E5A);
  static const Color onSurface = Color(0xFFDFE2EF);
  static const Color onSurfaceVariant = Color(0xFFE2BFB0);
  static const Color onBackground = Color(0xFFDFE2EF);
  static const Color inverseSurface = Color(0xFFDFE2EF);
  static const Color inverseOnSurface = Color(0xFF2C303A);
  static const Color outline = Color(0xFFA98A7D);
  static const Color outlineVariant = Color(0xFF5A4136);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF81C784);
  static const Color successContainer = Color(0xFF2E7D32);
  static const Color onSuccess = Color(0xFF1B5E20);

  static const LinearGradient amberGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB693), Color(0xFFFF6B00)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFAF8D11), Color(0xFFE9C349)],
  );

  static const List<BoxShadow> ctaShadow = [
    BoxShadow(
      color: Color(0x4DFF6B00), 
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> navBarShadow = [
    BoxShadow(
      color: Color(0x99000000), 
      blurRadius: 50,
      offset: Offset(0, -20),
    ),
  ];
  
  static const Color glassCardBg = Color(0x33353943); 
  static const Color glassPanelBg = Color(0x99262A34); 
}
