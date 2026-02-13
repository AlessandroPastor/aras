import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/network/network_info.dart';

/// Provider para gestionar el estado de conectividad
class ConnectivityProvider extends ChangeNotifier {
  final NetworkInfo networkInfo;
  
  bool _isConnected = false;
  bool _isSyncing = false;
  StreamSubscription? _connectivitySubscription;

  ConnectivityProvider({required this.networkInfo}) {
    _init();
  }

  // ==================== GETTERS ====================

  bool get isConnected => _isConnected;
  bool get isSyncing => _isSyncing;
  bool get isOffline => !_isConnected;

  // ==================== INICIALIZACIÓN ====================

  Future<void> _init() async {
    // Verificar estado inicial
    _isConnected = await networkInfo.isConnected;
    notifyListeners();

    // Escuchar cambios de conectividad
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) {
        _isConnected = isConnected;
        notifyListeners();
      },
    );
  }

  // ==================== MÉTODOS PÚBLICOS ====================

  /// Actualizar estado de sincronización
  void setSyncing(bool syncing) {
    _isSyncing = syncing;
    notifyListeners();
  }

  /// Verificar conectividad manualmente
  Future<void> checkConnectivity() async {
    _isConnected = await networkInfo.isConnected;
    notifyListeners();
  }

  // ==================== CLEANUP ====================

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
