import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1A3FFF);
  static const Color background = Color(0xFFF9FAFB);
  static const Color cardBg = Colors.white;
  static const Color textMain = Color(0xFF111827);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);

  // Category specific styles mapped from the React Native app
  static Color getBgForCategory(String slug) {
    switch (slug) {
      case 'cleaning': return const Color(0xFFE8F5E9);
      case 'plumbing': return const Color(0xFFE3F2FD);
      case 'electrician': return const Color(0xFFFFFDE7);
      case 'ac-service': return const Color(0xFFE0F7FA);
      case 'pest-control': return const Color(0xFFF3E5F5);
      case 'appliance-repair': return const Color(0xFFFFF3E0);
      case 'paint': return const Color(0xFFFCE4EC);
      default: return const Color(0xFFF5F5F5);
    }
  }

  static Color getColorForCategory(String slug) {
    switch (slug) {
      case 'cleaning': return const Color(0xFF388E3C);
      case 'plumbing': return const Color(0xFF1976D2);
      case 'electrician': return const Color(0xFFFBC02D);
      case 'ac-service': return const Color(0xFF0097A7);
      case 'pest-control': return const Color(0xFF7B1FA2);
      case 'appliance-repair': return const Color(0xFFF57C00);
      case 'paint': return const Color(0xFFD81B60);
      default: return const Color(0xFF666666);
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        background: background,
      ),
      useMaterial3: true,
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
    );
  }
}
