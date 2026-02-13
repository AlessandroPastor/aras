import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos de texto configurables y reutilizables
class AppTextStyles {
  // ==================== FUENTES ====================
  
  /// Fuente principal - Inter (moderna y legible)
  static const String primaryFont = 'Inter';
  
  /// Fuente secundaria - Poppins (para títulos)
  static const String secondaryFont = 'Poppins';
  
  /// Fuente monoespaciada - JetBrains Mono (para código/números)
  static const String monoFont = 'JetBrainsMono';
  
  // ==================== DISPLAY (Extra Large) ====================
  
  static TextStyle displayLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: 57,
    fontWeight: fontWeight ?? FontWeight.w700,
    color: color,
    letterSpacing: -0.25,
    height: 1.12,
  );
  
  static TextStyle displayMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: 45,
    fontWeight: fontWeight ?? FontWeight.w700,
    color: color,
    letterSpacing: 0,
    height: 1.16,
  );
  
  static TextStyle displaySmall({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: 36,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0,
    height: 1.22,
  );
  
  // ==================== HEADLINE (Títulos) ====================
  
  static TextStyle headlineLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: 32,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0,
    height: 1.25,
  );
  
  static TextStyle headlineMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: 28,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0,
    height: 1.29,
  );
  
  static TextStyle headlineSmall({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: secondaryFont,
    fontSize: 24,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0,
    height: 1.33,
  );
  
  // ==================== TITLE (Subtítulos) ====================
  
  static TextStyle titleLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0,
    height: 1.27,
  );
  
  static TextStyle titleMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static TextStyle titleSmall({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  // ==================== BODY (Texto de cuerpo) ====================
  
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color,
    letterSpacing: 0.25,
    height: 1.43,
  );
  
  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color,
    letterSpacing: 0.4,
    height: 1.33,
  );
  
  // ==================== LABEL (Etiquetas) ====================
  
  static TextStyle labelLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: fontWeight ?? FontWeight.w500,
    color: color,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  static TextStyle labelMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: fontWeight ?? FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
    height: 1.33,
  );
  
  static TextStyle labelSmall({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: fontWeight ?? FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
    height: 1.45,
  );
  
  // ==================== ESTILOS ESPECIALES ====================
  
  /// Estilo para botones
  static TextStyle button({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.white,
    letterSpacing: 0.5,
    height: 1.43,
  );
  
  /// Estilo para precios
  static TextStyle price({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: monoFont,
    fontSize: 20,
    fontWeight: fontWeight ?? FontWeight.w700,
    color: color ?? AppColors.primary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  /// Estilo para números/cantidades
  static TextStyle number({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontFamily: monoFont,
    fontSize: 16,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color,
    letterSpacing: 0,
    height: 1.5,
  );
  
  /// Estilo para badges/chips
  static TextStyle badge({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.white,
    letterSpacing: 0.5,
    height: 1.45,
  );
  
  /// Estilo para caption/ayuda
  static TextStyle caption({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textSecondaryLight,
    letterSpacing: 0.4,
    height: 1.33,
    fontStyle: FontStyle.italic,
  );
  
  /// Estilo para overline (texto pequeño en mayúsculas)
  static TextStyle overline({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textSecondaryLight,
    letterSpacing: 1.5,
    height: 1.6,
  );
}
