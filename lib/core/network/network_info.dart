import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface abstracta para verificar conectividad
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementación de NetworkInfo usando connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();
      // En versión 5.x, checkConnectivity retorna ConnectivityResult
      // En versión 6.x+, retorna List<ConnectivityResult>
      if (result is List<ConnectivityResult>) {
        return _hasConnection(result as List<ConnectivityResult>);
      } else {
        return _isConnected(result);
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((result) {
      // El stream emite ConnectivityResult individual
      return _isConnected(result);
    });
  }

  /// Verifica si hay conexión en una lista de resultados
  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => _isConnected(result));
  }

  /// Verifica si un resultado individual indica conexión
  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet;
  }
}
