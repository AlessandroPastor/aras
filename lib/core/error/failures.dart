/// Clase base abstracta para todos los fallos de la aplicación
abstract class Failure {
  final String message;
  
  const Failure(this.message);
  
  @override
  String toString() => message;
}

/// Fallo de servidor (errores HTTP 500+)
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor. Por favor, intenta más tarde.'])
      : super(message);
}

/// Fallo de caché/base de datos local
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Error al acceder a los datos locales.'])
      : super(message);
}

/// Fallo de red (sin conexión, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Error de conexión. Verifica tu internet.'])
      : super(message);
}

/// Fallo de validación (datos inválidos)
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Los datos proporcionados no son válidos.'])
      : super(message);
}

/// Fallo de autenticación (no autorizado)
class AuthFailure extends Failure {
  const AuthFailure([String message = 'No autorizado. Por favor, inicia sesión.'])
      : super(message);
}

/// Fallo de no encontrado (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Recurso no encontrado.'])
      : super(message);
}

/// Fallo de sincronización
class SyncFailure extends Failure {
  const SyncFailure([String message = 'Error al sincronizar datos.'])
      : super(message);
}

/// Fallo genérico para casos no específicos
class GenericFailure extends Failure {
  const GenericFailure([String message = 'Ha ocurrido un error inesperado.'])
      : super(message);
}
