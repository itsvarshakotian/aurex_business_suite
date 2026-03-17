import 'package:flutter/material.dart';

class ColorResources {
  //  CORE BACKGROUND 
  static const Color primaryBackground = Color(0xFF0E1117);  // Deep space bg
  static const Color secondaryBackground = Color(0xFF1A1D24); // Card/surface
  static const Color surface = Color(0xFF23262F);  // Inputs, overlays

  //  BRAND GRADIENTS 
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF1C40F), Color(0xFFF5D76E)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8E44AD), Color(0xFF9B59B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2D9CDB), Color(0xFF3498DB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //  SOLIDS 
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldSecondary = Color(0xFFF5D76E);
  static const Color accentPurple = Color(0xFF8E44AD);
  static const Color accentBlue = Color(0xFF2D9CDB);

  //  STATUS 
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFEB5757);
  static const Color errorLight = Color(0xFFE74C3C);
  static const Color info = Color(0xFF17A2B8);

  //  TEXT 
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A4AB);
  static const Color textTertiary = Color(0xFF6C757D);
  static const Color textMuted = Color(0xFF495057);

  //  BORDERS / SHADOWS
  static const Color borderLight = Color(0xFF2A2E3B);
  static const Color borderActive = Color(0xFFD4AF37);
  static const Color shadow = Color(0xFF0A0D12);

  // CHARTS / ACCENTS 
  static const Color chartLine = Color(0xFFD4AF37);
static const Color chartFill = Color(0x26D4AF37); // 15% opacity
}
