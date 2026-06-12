import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_search/core/constants/enums.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFF00CEC9);
  static const Color accentColor = Color(0xFFFD79A8);
  static const Color successColor = Color(0xFF00B894);
  static const Color warningColor = Color(0xFFFDCB6E);
  static const Color errorColor = Color(0xFFFF7675);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color xpColor = Color(0xFFA29BFE);

  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceMedium = Color(0xFF16213E);
  static const Color surfaceLight = Color(0xFF0F3460);

  static const Color textPrimary = Color(0xFFF5F6FA);
  static const Color textSecondary = Color(0xFFB2BEC3);
  static const Color textMuted = Color(0xFF636E72);

  static const _primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _secondaryGradient = LinearGradient(
    colors: [Color(0xFF00CEC9), Color(0xFF81ECEC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _accentGradient = LinearGradient(
    colors: [Color(0xFFFD79A8), Color(0xFFFAB1A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA502)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get primaryGradient => _primaryGradient;
  static LinearGradient get secondaryGradient => _secondaryGradient;
  static LinearGradient get accentGradient => _accentGradient;
  static LinearGradient get goldGradient => _goldGradient;

  static LinearGradient gameCategoryGradient(ThemeCategory category) {
    switch (category) {
      case ThemeCategory.animals:
        return const LinearGradient(
          colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
        );
      case ThemeCategory.countries:
        return const LinearGradient(
          colors: [Color(0xFF2980B9), Color(0xFF3498DB)],
        );
      case ThemeCategory.food:
        return const LinearGradient(
          colors: [Color(0xFFE67E22), Color(0xFFF39C12)],
        );
      case ThemeCategory.sports:
        return const LinearGradient(
          colors: [Color(0xFFC0392B), Color(0xFFE74C3C)],
        );
      case ThemeCategory.science:
        return const LinearGradient(
          colors: [Color(0xFF8E44AD), Color(0xFF9B59B6)],
        );
      case ThemeCategory.technology:
        return const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
        );
      case ThemeCategory.movies:
        return const LinearGradient(
          colors: [Color(0xFFD35400), Color(0xFFE67E22)],
        );
      case ThemeCategory.nature:
        return const LinearGradient(
          colors: [Color(0xFF16A085), Color(0xFF1ABC9C)],
        );
      case ThemeCategory.history:
        return const LinearGradient(
          colors: [Color(0xFF7F8C8D), Color(0xFF95A5A6)],
        );
      case ThemeCategory.space:
        return const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
        );
      case ThemeCategory.mixed:
        return primaryGradient;
    }
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surfaceDark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceDark,
        error: errorColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyLarge: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          labelMedium: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceMedium.withValues(alpha: 0.8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMedium.withValues(alpha: 0.6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: surfaceLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceMedium,
        contentTextStyle: TextStyle(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceMedium,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
      ),
      dividerTheme: const DividerThemeData(
        color: surfaceLight,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      extensions: const [_GameColors()],
    );
  }
}

class _GameColors extends ThemeExtension<_GameColors> {
  const _GameColors();

  @override
  ThemeExtension<_GameColors> copyWith() => this;

  @override
  ThemeExtension<_GameColors> lerp(
    covariant ThemeExtension<_GameColors>? other,
    double t,
  ) => this;
}
