import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/sync_products.dart';

/// Estados posibles del provider
enum ProductState {
  initial,
  loading,
  loaded,
  error,
}

/// Provider para gestionar el estado de productos
class ProductProvider extends ChangeNotifier {
  final CreateProduct createProductUseCase;
  final GetProducts getProductsUseCase;
  final GetProduct getProductUseCase;
  final UpdateProduct updateProductUseCase;
  final DeleteProduct deleteProductUseCase;
  final SyncProducts syncProductsUseCase;

  ProductProvider({
    required this.createProductUseCase,
    required this.getProductsUseCase,
    required this.getProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.syncProductsUseCase,
  });

  // ==================== ESTADO ====================

  ProductState _state = ProductState.initial;
  List<Product> _products = [];
  String? _errorMessage;
  bool _isSyncing = false;

  // ==================== GETTERS ====================

  ProductState get state => _state;
  List<Product> get products => _products;
  String? get errorMessage => _errorMessage;
  bool get isSyncing => _isSyncing;
  bool get isLoading => _state == ProductState.loading;
  bool get hasError => _state == ProductState.error;

  // ==================== MÉTODOS PÚBLICOS ====================

  /// Cargar todos los productos
  Future<void> loadProducts() async {
    _setState(ProductState.loading);

    final result = await getProductsUseCase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(ProductState.error);
      },
      (products) {
        _products = products;
        _errorMessage = null;
        _setState(ProductState.loaded);
      },
    );
  }

  /// Crear un nuevo producto
  Future<bool> createProduct({
    required String name,
    String? description,
    required double price,
    required int stock,
  }) async {
    _setState(ProductState.loading);

    final params = CreateProductParams(
      name: name,
      description: description,
      price: price,
      stock: stock,
    );

    final result = await createProductUseCase(params);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(ProductState.error);
        return false;
      },
      (product) {
        _products.insert(0, product); // Agregar al inicio
        _errorMessage = null;
        _setState(ProductState.loaded);
        return true;
      },
    );
  }

  /// Actualizar un producto existente
  Future<bool> updateProduct({
    required int id,
    int? serverId,
    required String name,
    String? description,
    required double price,
    required int stock,
    required DateTime createdAt,
  }) async {
    _setState(ProductState.loading);

    final params = UpdateProductParams(
      id: id,
      serverId: serverId,
      name: name,
      description: description,
      price: price,
      stock: stock,
      createdAt: createdAt,
    );

    final result = await updateProductUseCase(params);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(ProductState.error);
        return false;
      },
      (updatedProduct) {
        // Actualizar en la lista
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = updatedProduct;
        }
        _errorMessage = null;
        _setState(ProductState.loaded);
        return true;
      },
    );
  }

  /// Eliminar un producto
  Future<bool> deleteProduct(int id) async {
    _setState(ProductState.loading);

    final result = await deleteProductUseCase(id);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(ProductState.error);
        return false;
      },
      (_) {
        // Remover de la lista
        _products.removeWhere((p) => p.id == id);
        _errorMessage = null;
        _setState(ProductState.loaded);
        return true;
      },
    );
  }

  /// Sincronizar productos con el servidor
  Future<bool> syncProducts() async {
    _isSyncing = true;
    notifyListeners();

    final result = await syncProductsUseCase();

    _isSyncing = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        // Recargar productos después de sincronizar
        loadProducts();
        return true;
      },
    );
  }

  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    if (_state == ProductState.error) {
      _setState(ProductState.loaded);
    }
  }

  // ==================== MÉTODOS PRIVADOS ====================

  void _setState(ProductState newState) {
    _state = newState;
    notifyListeners();
  }

  updateExistingProduct(Product updatedProduct) {}
}
