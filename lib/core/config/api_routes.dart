import 'app_config.dart';

/// Rutas de API centralizadas y reutilizables
/// Todas las rutas de la aplicación deben definirse aquí
class ApiRoutes {
  // Instancia de configuración
  static final _config = AppConfig();
  
  // ==================== RUTA BASE ====================
  
  /// Prefijo base para todas las rutas de API
  static const String apiPrefix = '/api';
  
  // ==================== RUTAS DE PRODUCTOS ====================
  
  /// Ruta base para productos
  static const String products = '$apiPrefix/products';
  
  /// Obtener un producto específico por ID
  /// Uso: ApiRoutes.productById('123')
  static String productById(String id) => '$products/$id';
  
  /// Crear un nuevo producto
  static String createProduct() => products;
  
  /// Actualizar un producto existente
  static String updateProduct(String id) => '$products/$id';
  
  /// Eliminar un producto
  static String deleteProduct(String id) => '$products/$id';
  
  /// Listar todos los productos
  static String listProducts() => products;
  
  /// Buscar productos (con query parameters)
  /// Uso: ApiRoutes.searchProducts({'name': 'laptop', 'minPrice': '100'})
  static String searchProducts([Map<String, String>? queryParams]) {
    if (queryParams == null || queryParams.isEmpty) {
      return products;
    }
    final query = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '$products?$query';
  }
  
  // ==================== RUTAS DE CATEGORÍAS ====================
  
  /// Ruta base para categorías
  static const String categories = '$apiPrefix/categories';
  
  /// Obtener una categoría específica por ID
  static String categoryById(String id) => '$categories/$id';
  
  /// Crear una nueva categoría
  static String createCategory() => categories;
  
  /// Actualizar una categoría existente
  static String updateCategory(String id) => '$categories/$id';
  
  /// Eliminar una categoría
  static String deleteCategory(String id) => '$categories/$id';
  
  /// Listar todas las categorías
  static String listCategories() => categories;
  
  // ==================== RUTAS DE AUTENTICACIÓN (para futuro) ====================
  
  /// Ruta base para autenticación
  static const String auth = '$apiPrefix/auth';
  
  /// Login de usuario
  static String login() => '$auth/login';
  
  /// Registro de usuario
  static String register() => '$auth/register';
  
  /// Logout de usuario
  static String logout() => '$auth/logout';
  
  /// Refrescar token
  static String refreshToken() => '$auth/refresh';
  
  // ==================== RUTAS DE SINCRONIZACIÓN ====================
  
  /// Ruta base para sincronización
  static const String sync = '$apiPrefix/sync';
  
  /// Sincronizar productos
  static String syncProducts() => '$sync/products';
  
  /// Obtener cambios desde una fecha
  static String syncSince(DateTime since) {
    final timestamp = since.millisecondsSinceEpoch;
    return '$sync/products?since=$timestamp';
  }
  
  // ==================== MÉTODOS DE UTILIDAD ====================
  
  /// Construir URL completa con la configuración actual
  /// Uso: ApiRoutes.buildUrl(ApiRoutes.products)
  static String buildUrl(String path) {
    return _config.getFullUrl(path);
  }
  
  /// Construir URL con parámetros de query
  /// Uso: ApiRoutes.buildUrlWithQuery('/products', {'limit': '10'})
  static String buildUrlWithQuery(String path, Map<String, String> queryParams) {
    final uri = Uri.parse(_config.getFullUrl(path));
    final newUri = uri.replace(queryParameters: queryParams);
    return newUri.toString();
  }
  
  /// Construir URL con path parameters
  /// Uso: ApiRoutes.buildUrlWithParams('/products/:id', {'id': '123'})
  static String buildUrlWithParams(String path, Map<String, String> params) {
    var finalPath = path;
    params.forEach((key, value) {
      finalPath = finalPath.replaceAll(':$key', value);
    });
    return _config.getFullUrl(finalPath);
  }
}
