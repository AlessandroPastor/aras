import 'package:flutter/material.dart';

/// Paleta de colores profesional Azul y Blanco para Modo Día/Noche
class AppColors {
  // ==================== COLORES BASE ====================
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // ==================== COLORES PRINCIPALES (MODO DÍA) ====================
  
  /// Color primario - Azul Profesional
  static const Color primaryLight = Color(0xFF1976D2); // Blue 700
  
  /// Color secundario - Azul Claro
  static const Color secondaryLight = Color(0xFF42A5F5); // Blue 400
  
  /// Color de acento - Azul Oscuro
  static const Color accentLight = Color(0xFF0D47A1); // Blue 900
  
  /// Fondo principal modo día
  static const Color backgroundLight = Color(0xFFF5F5F5); // Gray 100
  
  /// Superficie modo día
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  
  /// Texto primario modo día
  static const Color textPrimaryLight = Color(0xFF212121); // Gray 900
  
  /// Texto secundario modo día
  static const Color textSecondaryLight = Color(0xFF757575); // Gray 600
  
  // ==================== COLORES PRINCIPALES (MODO NOCHE) ====================
  
  /// Color primario - Azul Claro para contraste
  static const Color primaryDark = Color(0xFF64B5F6); // Blue 300
  
  /// Color secundario - Azul Medio
  static const Color secondaryDark = Color(0xFF90CAF9); // Blue 200
  
  /// Color de acento - Azul Brillante
  static const Color accentDark = Color(0xFF42A5F5); // Blue 400
  
  /// Fondo principal modo noche
  static const Color backgroundDark = Color(0xFF121212); // Almost Black
  
  /// Superficie modo noche
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark Gray
  
  /// Texto primario modo noche
  static const Color textPrimaryDark = Color(0xFFE0E0E0); // Gray 300
  
  /// Texto secundario modo noche
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Gray 400
  
  // ==================== ALIASES PARA COMPATIBILIDAD ====================
  
  /// Alias para color primario (usa modo día por defecto)
  static const Color primary = primaryLight;
  
  /// Alias para color secundario (usa modo día por defecto)
  static const Color secondary = secondaryLight;
  
  /// Alias para color de acento (usa modo día por defecto)
  static const Color accent = accentLight;
  
  /// Alias para container primario (usa modo día por defecto)
  static const Color primaryContainer = primaryContainerLight;
  
  /// Overlay para modales
  static const Color overlay = Color(0x66000000); // 40% negro
  
  // ==================== COLORES DE ESTADO (AMBOS MODOS) ====================
  
  /// Color de éxito
  static const Color success = Color(0xFF2E7D32); // Green 800
  static const Color successLight = Color(0xFF66BB6A); // Green 400
  
  /// Color de advertencia
  static const Color warning = Color(0xFFF57C00); // Orange 800
  static const Color warningLight = Color(0xFFFFB74D); // Orange 300
  
  /// Color de error
  static const Color error = Color(0xFFC62828); // Red 800
  static const Color errorLight = Color(0xFFEF5350); // Red 400
  
  /// Color de información
  static const Color info = Color(0xFF1976D2); // Blue 700
  static const Color infoLight = Color(0xFF42A5F5); // Blue 400
  
  // ==================== CONTAINERS ====================
  
  static const Color primaryContainerLight = Color(0xFFE3F2FD); // Blue 50
  static const Color primaryContainerDark = Color(0xFF0D47A1); // Blue 900
  
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color infoContainer = Color(0xFFE3F2FD);
  
  // ==================== ESCALA DE GRISES ====================
  
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);
  
  // ==================== GRADIENTES MODO DÍA ====================
  
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradientLight = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== GRADIENTES MODO NOCHE ====================
  
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradientDark = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== SOMBRAS ====================
  
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> strongShadow = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
  
  // ==================== COLORES PARA CATEGORÍAS ====================
  
  /// Paleta para categorías - Tonos azules
  static const List<Color> categoryColors = [
    Color(0xFF1976D2), // Blue 700
    Color(0xFF1565C0), // Blue 800
    Color(0xFF0D47A1), // Blue 900
    Color(0xFF42A5F5), // Blue 400
    Color(0xFF2196F3), // Blue 500
    Color(0xFF64B5F6), // Blue 300
    Color(0xFF90CAF9), // Blue 200
    Color(0xFF0277BD), // Light Blue 800
  ];
  
  static const List<String> categoryColorHex = [
    '#1976D2',
    '#1565C0',
    '#0D47A1',
    '#42A5F5',
    '#2196F3',
    '#64B5F6',
    '#90CAF9',
    '#0277BD',
  ];
  
  static const List<String> categoryColorNames = [
    'Azul',
    'Azul Oscuro',
    'Azul Marino',
    'Azul Claro',
    'Azul Medio',
    'Azul Suave',
    'Azul Pastel',
    'Azul Cielo',
  ];

  static var primaryGradient;

  static var successGradient;
}
