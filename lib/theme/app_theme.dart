import 'package:flutter/material.dart';

/// [AppColors] defines the brand color palette for the Medicine App.
/// It includes brand-specific colors, semantic colors for feedback,
/// and legacy convenience colors for surfaces and text.
class AppColors {
  // Brand — Caby24
  static const Color primary = Color(0xFF12E0FF);
  static const Color primaryAccent = Color(0xFF00B8D4);
  static const Color secondary = Color(0xFF12E0FF);
  static const Color secondaryCyan = Color(0xFF008396);
  static const Color silver = Color(0xFF737373);
  static const Color darkCyan = Color(0xFF005A6B);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // Misc
  static const Color online = Color(0xFF22C55E);
  static const Color offline = Color(0xFF9CA3AF);
  static const Color starYellow = Color(0xFFFFB800);
  static const Color purple = Color(0xFF8B5CF6);

  // Service Categories
  static const Color ambulance = Color(0xFFE53E3E);
  static const Color parcel = Color(0xFF008396);
  static const Color heavyHaul = Color(0xFF2B6CB0);
  static const Color carBooking = Color(0xFF12E0FF);
  static const Color foodDelivery = Color(0xFF38A169);
  static const Color beverages = Color(0xFF805AD5);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Colors.white;
  static const Color blush = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Colors.white;
}

/// [AppSpacing] provides consistent layout measurements for modern screens.
/// Optimized for high-ratio devices like S25, S26, Pixel 9a, and iPhone 17.
class AppSpacing {
  static const double screenPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double elementGap = 12.0;
  static const double sectionGap = 24.0;
  static const double borderRadius = 24.0; // Extra rounded for modern look
  static const double cardRadius = 20.0;
}

/// [AppTextStyles] manages the typography system.
/// Uses 'Fraunces' for premium headers and 'Lexend' for functional text.
class AppTextStyles {
  static const String _fontHeading = 'Fraunces';
  static const String _fontBody = 'Lexend';

  // Header - Bold, Premium, Editorial feel
  static const TextStyle header = TextStyle(
    fontFamily: _fontHeading,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle subHeader = TextStyle(
    fontFamily: _fontHeading,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Tagline - Modern, Clean
  static const TextStyle tagline = TextStyle(
    fontFamily: _fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryAccent,
    letterSpacing: 1.2,
    textBaseline: TextBaseline.alphabetic,
  );

  // Description - Highly readable
  static const TextStyle description = TextStyle(
    fontFamily: _fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Caption - Subtle utility text
  static const TextStyle caption = TextStyle(
    fontFamily: _fontBody,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.2,
  );

  // Card Title
  static const TextStyle cardTitle = TextStyle(
    fontFamily: _fontBody,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}

/// [AppTheme] returns a [ThemeData] object configured with the modern medicine app aesthetic.
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),

      // Typography
      fontFamily: 'Lexend', // Default body font
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.header,
        headlineMedium: AppTextStyles.subHeader,
        bodyLarge: AppTextStyles.description,
        bodyMedium: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        labelSmall: AppTextStyles.caption,
      ),

      // Card Design
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: BorderSide(color: AppColors.divider.withAlpha(128), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),

      // Button Designs
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      // Input Decoration (TextFields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: AppTextStyles.caption,
      ),

      // AppBar Design
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.subHeader,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}

/// [AppCardStyles] contains reusable BoxDecoration for non-Material cards
/// or special containers to maintain the sleek look.
class AppCardStyles {
  static BoxDecoration get sleekCard => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF000000).withAlpha(10),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
    border: Border.all(color: AppColors.divider.withAlpha(128)),
  );

  static BoxDecoration get primaryGradientCard => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withAlpha(77),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
