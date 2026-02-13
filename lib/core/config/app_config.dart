/// Configuración global de la aplicación
/// Singleton pattern para acceso centralizado a configuraciones
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  
  factory AppConfig() {
    return _instance;
  }
  
  AppConfig._internal();

  // ==================== CONFIGURACIÓN DE ENTORNOS ====================
  
  /// Entorno actual de la aplicación
  Environment currentEnvironment = Environment.development;
  
  /// URL base según el entorno
  String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return developmentBaseUrl;
      case Environment.staging:
        return stagingBaseUrl;
      case Environment.production:
        return productionBaseUrl;
    }
  }
  
  // URLs configurables por entorno
  String developmentBaseUrl = 'http://localhost:8000';
  String stagingBaseUrl = 'https://staging-api.tudominio.com';
  String productionBaseUrl = 'https://api.tudominio.com';
  
  // ==================== CONFIGURACIÓN DE RED ====================
  
  /// Timeout para peticiones HTTP (en segundos)
  int connectionTimeout = 30;
  
  /// Timeout para recibir respuesta (en segundos)
  int receiveTimeout = 30;
  
  /// Número de reintentos en caso de fallo
  int maxRetries = 3;
  
  /// Delay entre reintentos (en milisegundos)
  int retryDelay = 1000;
  
  // ==================== CONFIGURACIÓN DE BASE DE DATOS ====================
  
  /// Nombre de la base de datos local
  String get databaseName => 'aras_app.db';
  
  /// Versión de la base de datos (incrementar para migraciones)
  int get databaseVersion => 1;
  
  // ==================== CONFIGURACIÓN DE SINCRONIZACIÓN ====================
  
  /// Intervalo de sincronización automática (en minutos)
  int syncInterval = 15;
  
  /// Sincronizar automáticamente al detectar conexión
  bool autoSyncOnConnection = true;
  
  /// Sincronizar automáticamente al iniciar la app
  bool syncOnAppStart = true;
  
  // ==================== MÉTODOS DE UTILIDAD ====================
  
  /// Cambiar entorno de la aplicación
  void setEnvironment(Environment env) {
    currentEnvironment = env;
  }
  
  /// Configurar URL base personalizada (útil para desarrollo)
  void setCustomBaseUrl(String url) {
    developmentBaseUrl = url;
  }
  
  /// Obtener URL completa con path
  String getFullUrl(String path) {
    // Asegurar que el path comience con /
    final cleanPath = path.startsWith('/') ? path : '/$path';
    // Asegurar que la base URL no termine con /
    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;
    return '$cleanBaseUrl$cleanPath';
  }
  
  /// Resetear a configuración por defecto
  void reset() {
    currentEnvironment = Environment.development;
    developmentBaseUrl = 'http://localhost:8000';
    stagingBaseUrl = 'https://staging-api.tudominio.com';
    productionBaseUrl = 'https://api.tudominio.com';
    connectionTimeout = 30;
    receiveTimeout = 30;
    maxRetries = 3;
    retryDelay = 1000;
    syncInterval = 15;
    autoSyncOnConnection = true;
    syncOnAppStart = true;
  }
}

/// Enumeración de entornos disponibles
enum Environment {
  development,
  staging,
  production,
}
