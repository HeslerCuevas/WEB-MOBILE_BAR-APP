import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final epilogue = GoogleFonts.epilogueTextTheme(
      ThemeData.dark().textTheme,
    );
    final manrope = GoogleFonts.manropeTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        surfaceBright: AppColors.surfaceBright,
        surfaceDim: AppColors.surfaceDim,
      ),


      textTheme: TextTheme(

        displayLarge: epilogue.displayLarge!.copyWith(
          fontWeight: FontWeight.w900,
          color: AppColors.onSurface,
          letterSpacing: -1.5,
        ),
        displayMedium: epilogue.displayMedium!.copyWith(
          fontWeight: FontWeight.w900,
          color: AppColors.onSurface,
          letterSpacing: -0.5,
        ),
        displaySmall: epilogue.displaySmall!.copyWith(
          fontWeight: FontWeight.w900,
          color: AppColors.onSurface,
        ),

        headlineLarge: epilogue.headlineLarge!.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
          letterSpacing: -0.5,
        ),
        headlineMedium: epilogue.headlineMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        headlineSmall: epilogue.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleLarge: epilogue.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleMedium: epilogue.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleSmall: epilogue.titleSmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: manrope.bodyLarge!.copyWith(
          color: AppColors.onSurface,
        ),
        bodyMedium: manrope.bodyMedium!.copyWith(
          color: AppColors.onSurface,
        ),
        bodySmall: manrope.bodySmall!.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: manrope.labelLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
          letterSpacing: 1.2,
        ),
        labelMedium: manrope.labelMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1.5,
        ),
        labelSmall: manrope.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 2.0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.tertiary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        hintStyle: GoogleFonts.manrope(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
        labelStyle: GoogleFonts.manrope(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 2.0,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.epilogue(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: 3,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.primary,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
