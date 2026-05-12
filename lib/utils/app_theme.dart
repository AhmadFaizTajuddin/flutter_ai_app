import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Dark Cyber/Tech aesthetic
  static const Color primary = Color(0xFF00F5FF); // Cyan neon
  static const Color secondary = Color(0xFF7B2FFF); // Electric purple
  static const Color accent = Color(0xFF00FF88); // Matrix green
  static const Color warning = Color(0xFFFF6B35); // Tech orange
  static const Color error = Color(0xFFFF2D55); // Alert red

  static const Color bgDark = Color(0xFF030712); // Near black
  static const Color bgCard = Color(0xFF0D1117); // GitHub dark
  static const Color bgSurface = Color(0xFF161B22); // Surface
  static const Color bgElevated = Color(0xFF1C2128); // Elevated

  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);
  static const Color border = Color(0xFF21262D);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: bgSurface,
        error: error,
        onPrimary: bgDark,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      fontFamily: 'monospace',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 11,
          letterSpacing: 0.8,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: bgDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      iconTheme: const IconThemeData(color: textSecondary),
    );
  }
}

// Custom gradient & effect helpers
class AppGradients {
  static LinearGradient get primaryGlow => const LinearGradient(
        colors: [Color(0xFF00F5FF), Color(0xFF7B2FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get cardGlow => LinearGradient(
        colors: [
          const Color(0xFF00F5FF).withOpacity(0.05),
          const Color(0xFF7B2FFF).withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get greenGlow => LinearGradient(
        colors: [
          const Color(0xFF00FF88).withOpacity(0.1),
          const Color(0xFF00F5FF).withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
