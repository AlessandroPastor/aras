import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../error/failures.dart';

/// Cliente HTTP reutilizable para todas las peticiones de la aplicación
class ApiClient {
  final http.Client client;
  final AppConfig config;

  ApiClient({
    required this.client,
    required this.config,
  });

  // ==================== HEADERS COMUNES ====================

  /// Headers por defecto para todas las peticiones
  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Headers con autenticación (para futuro)
  Map<String, String> _headersWithAuth([String? token]) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ==================== MÉTODOS HTTP ====================

  /// GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUri(url, queryParams);
      final response = await client
          .get(
            uri,
            headers: headers ?? _defaultHeaders,
          )
          .timeout(Duration(seconds: config.connectionTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure('Tiempo de espera agotado');
    } catch (e) {
      throw NetworkFailure('Error de red: ${e.toString()}');
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await client
          .post(
            uri,
            headers: headers ?? _defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(seconds: config.connectionTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure('Tiempo de espera agotado');
    } catch (e) {
      throw NetworkFailure('Error de red: ${e.toString()}');
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await client
          .put(
            uri,
            headers: headers ?? _defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(seconds: config.connectionTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure('Tiempo de espera agotado');
    } catch (e) {
      throw NetworkFailure('Error de red: ${e.toString()}');
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await client
          .delete(
            uri,
            headers: headers ?? _defaultHeaders,
          )
          .timeout(Duration(seconds: config.connectionTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkFailure('Tiempo de espera agotado');
    } catch (e) {
      throw NetworkFailure('Error de red: ${e.toString()}');
    }
  }

  // ==================== MÉTODOS DE UTILIDAD ====================

  /// Construir URI con query parameters
  Uri _buildUri(String url, Map<String, String>? queryParams) {
    final uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  /// Manejar respuesta HTTP
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Respuesta exitosa
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw const AuthFailure('No autorizado');
    } else if (response.statusCode == 404) {
      throw const NotFoundFailure('Recurso no encontrado');
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      // Error del cliente
      final errorMessage = _extractErrorMessage(response.body);
      throw ValidationFailure(errorMessage);
    } else if (response.statusCode >= 500) {
      // Error del servidor
      throw const ServerFailure('Error del servidor');
    } else {
      throw GenericFailure('Error inesperado: ${response.statusCode}');
    }
  }

  /// Extraer mensaje de error del body
  String _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        return json['message'] ?? json['error'] ?? 'Error de validación';
      }
      return 'Error de validación';
    } catch (e) {
      return 'Error de validación';
    }
  }

  /// Retry logic para peticiones fallidas
  Future<T> withRetry<T>(
    Future<T> Function() request, {
    int? maxRetries,
  }) async {
    final retries = maxRetries ?? config.maxRetries;
    int attempts = 0;

    while (attempts < retries) {
      try {
        return await request();
      } catch (e) {
        attempts++;
        if (attempts >= retries) {
          rethrow;
        }
        // Esperar antes de reintentar
        await Future.delayed(Duration(milliseconds: config.retryDelay));
      }
    }

    throw const GenericFailure('Máximo de reintentos alcanzado');
  }
}
