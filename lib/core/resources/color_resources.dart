import 'package:flutter/material.dart';

class ColorResources {
  static const Color primaryBackground = Color(0xFF0B1220);
  static const Color secondaryBackground = Color(0xFF0F172A);
  static const Color tertiaryBackground = Color(0xFF020617);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFF1F2937);
  static Color glass = Colors.white.withValues(alpha:0.05);
  static Color glassBorder = Colors.white.withValues(alpha:0.08);
  static const Color elevatedSurface = Color(0xFF1A1D24);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldSecondary = Color(0xFFF5D76E);
  static const Color accentBlue = Color(0xFF2D9CDB);
  static const Color accentPurple = Color(0xFF8E44AD);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A4AB);
  static const Color textTertiary = Color(0xFF6C757D);
  static const Color textMuted = Color(0xFF495057);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFEB5757);
  static const Color info = Color(0xFF17A2B8);
  static const Color lightyellow = Color(0xFFDDBB55);
  static const Color borderLight = Color(0xFF2A2E3B);
  static const Color borderMedium = Color(0xFF3A3F4B);
  static const Color borderActive = goldPrimary;
  static Color divider = Colors.white.withValues(alpha:0.1);
  static Color buttonDisabled = Colors.grey.withValues(alpha:0.3);
  static Color ripple = Colors.white.withValues(alpha:0.08);
  static const Color chartLine = goldPrimary;
  static const Color chartFill = Color(0x26D4AF37);
  static const Color shadowDark = Color(0xFF000000);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldPrimary, goldSecondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient screenGradient = LinearGradient(
    colors: [primaryBackground, secondaryBackground, tertiaryBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2D9CDB), Color(0xFF56CCF2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8E44AD), Color(0xFFB784F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Glow gradients (used in profile header)
  static LinearGradient glowBlue = LinearGradient(
    colors: [accentBlue.withValues(alpha:0.4), accentBlue.withValues(alpha:0.1)],
  );

  static LinearGradient glowPurple = LinearGradient(
    colors: [accentPurple.withValues(alpha :0.4), accentPurple.withOpacity(0.1)],
  );

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: shadowDark.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static Color profileCircle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? ColorResources.lightyellow
        : ColorResources.accentPurple;
  }
}
