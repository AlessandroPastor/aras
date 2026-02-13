import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Configuración completa del tema de la aplicación
class AppTheme {
  // ==================== TEMA CLARO ====================
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Esquema de colores
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primaryDark,
      
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,

      tertiary: AppColors.accent,
      onTertiary: AppColors.white,
      tertiaryContainer: const Color(0xFFFCE7F3), // Pink-50

      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorContainer,

      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainerHighest: AppColors.gray100,
      
      outline: AppColors.gray300,
      outlineVariant: AppColors.gray200,
      
      shadow: AppColors.gray900,
      scrim: AppColors.overlay,
    ),
    
    // Tipografía
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge(color: AppColors.textPrimaryLight),
      displayMedium: AppTextStyles.displayMedium(color: AppColors.textPrimaryLight),
      displaySmall: AppTextStyles.displaySmall(color: AppColors.textPrimaryLight),
      
      headlineLarge: AppTextStyles.headlineLarge(color: AppColors.textPrimaryLight),
      headlineMedium: AppTextStyles.headlineMedium(color: AppColors.textPrimaryLight),
      headlineSmall: AppTextStyles.headlineSmall(color: AppColors.textPrimaryLight),
      
      titleLarge: AppTextStyles.titleLarge(color: AppColors.textPrimaryLight),
      titleMedium: AppTextStyles.titleMedium(color: AppColors.textPrimaryLight),
      titleSmall: AppTextStyles.titleSmall(color: AppColors.textPrimaryLight),
      
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.textPrimaryLight),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.textPrimaryLight),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.textSecondaryLight),
      
      labelLarge: AppTextStyles.labelLarge(color: AppColors.textPrimaryLight),
      labelMedium: AppTextStyles.labelMedium(color: AppColors.textSecondaryLight),
      labelSmall: AppTextStyles.labelSmall(color: AppColors.textSecondaryLight),
    ),
    
    // AppBar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      titleTextStyle: AppTextStyles.titleLarge(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
    ),
    
    // Cards
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.gray200, width: 1),
      ),
      color: AppColors.primary,
      shadowColor: AppColors.gray900.withOpacity(0.1),
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
      hintStyle: AppTextStyles.bodyMedium(color: AppColors.textPrimaryLight),
      errorStyle: AppTextStyles.bodySmall(color: AppColors.error),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.button(),
      ),
    ),
    
    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary, width: 2),
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button(color: AppColors.primary),
      ),
    ),
    
    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button(color: AppColors.primary),
      ),
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primaryContainer,
      labelStyle: AppTextStyles.labelMedium(color: AppColors.primaryDark),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    
    // Dialog
    dialogTheme: DialogTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.surfaceLight,
      titleTextStyle: AppTextStyles.headlineSmall(color: AppColors.textPrimaryLight),
      contentTextStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
    ),
    
    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.surfaceLight,
    ),
    
    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.gray200,
      thickness: 1,
      space: 1,
    ),
    
    // Icon
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryLight,
      size: 24,
    ),
  );
  
  // ==================== TEMA OSCURO ====================
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Esquema de colores
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.backgroundDark,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      
      secondary: AppColors.secondary,
      onSecondary: AppColors.backgroundDark,
      secondaryContainer: AppColors.secondary,
      onSecondaryContainer: AppColors.secondary,
      
      tertiary: AppColors.accent,
      onTertiary: AppColors.backgroundDark,
      tertiaryContainer: AppColors.accent,
      onTertiaryContainer: AppColors.accent,
      
      error: AppColors.error,
      onError: AppColors.backgroundDark,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.error,
      
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.gray700,
      
      outline: AppColors.gray600,
      outlineVariant: AppColors.gray700,
      
      shadow: AppColors.black,
      scrim: AppColors.overlay,
    ),
    
    // Tipografía
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge(color: AppColors.textPrimaryDark),
      displayMedium: AppTextStyles.displayMedium(color: AppColors.textPrimaryDark),
      displaySmall: AppTextStyles.displaySmall(color: AppColors.textPrimaryDark),
      
      headlineLarge: AppTextStyles.headlineLarge(color: AppColors.textPrimaryDark),
      headlineMedium: AppTextStyles.headlineMedium(color: AppColors.textPrimaryDark),
      headlineSmall: AppTextStyles.headlineSmall(color: AppColors.textPrimaryDark),
      
      titleLarge: AppTextStyles.titleLarge(color: AppColors.textPrimaryDark),
      titleMedium: AppTextStyles.titleMedium(color: AppColors.textPrimaryDark),
      titleSmall: AppTextStyles.titleSmall(color: AppColors.textPrimaryDark),
      
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.textPrimaryDark),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.textPrimaryDark),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.textSecondaryDark),
      
      labelLarge: AppTextStyles.labelLarge(color: AppColors.textPrimaryDark),
      labelMedium: AppTextStyles.labelMedium(color: AppColors.textSecondaryDark),
      labelSmall: AppTextStyles.labelSmall(color: AppColors.textSecondaryDark),
    ),
    
    // AppBar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: AppTextStyles.titleLarge(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
    ),
    
    // Cards
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.gray700, width: 1),
      ),
      color: AppColors.primary,
      shadowColor: AppColors.black.withOpacity(0.3),
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondaryDark),
      hintStyle: AppTextStyles.bodyMedium(color: AppColors.textPrimaryLight),
      errorStyle: AppTextStyles.bodySmall(color: AppColors.error),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.backgroundDark,
        textStyle: AppTextStyles.button(color: AppColors.backgroundDark),
      ),
    ),
    
    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: AppColors.primaryLight, width: 2),
        foregroundColor: AppColors.primaryLight,
        textStyle: AppTextStyles.button(color: AppColors.primaryLight),
      ),
    ),
    
    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        foregroundColor: AppColors.primaryLight,
        textStyle: AppTextStyles.button(color: AppColors.primaryLight),
      ),
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primaryDark,
      labelStyle: AppTextStyles.labelMedium(color: AppColors.primaryLight),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    
    // Dialog
    dialogTheme: DialogTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.surfaceDark,
      titleTextStyle: AppTextStyles.headlineSmall(color: AppColors.textPrimaryDark),
      contentTextStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondaryDark),
    ),
    
    // Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.surfaceDark,
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: AppColors.gray700,
      thickness: 1,
      space: 1,
    ),
    
    // Icon
    iconTheme: IconThemeData(
      color: AppColors.textPrimaryDark,
      size: 24,
    ),
  );
}
