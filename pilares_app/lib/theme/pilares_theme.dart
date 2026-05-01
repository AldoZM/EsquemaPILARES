// lib/theme/pilares_theme.dart
import 'package:flutter/material.dart';

class PilaresTheme {
  static const Color primaryGreen = Color(0xFF1B5E35);
  static const Color lightGreen = Color(0xFF2D6A4F);
  static const Color background = Color(0xFFF5F7F5);
  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFE0E0E0);
  static const Color subtleText = Color(0xFF888888);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
