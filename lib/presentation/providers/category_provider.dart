import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/sync_categories.dart';

/// Provider para manejar el estado de las categorías
class CategoryProvider with ChangeNotifier {
  final GetCategories getCategories;
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;
  final SyncCategories syncCategories;

  CategoryProvider({
    required this.getCategories,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.syncCategories,
  });

  // ==================== ESTADO ====================

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // ==================== MÉTODOS ====================

  /// Cargar todas las categorías
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getCategories();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (categories) {
        _categories = categories;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Crear una nueva categoría
  Future<bool> createNewCategory({
    required String name,
    String? description,
    String? icon,
    String? color,
  }) async {
    _errorMessage = null;

    final params = CreateCategoryParams(
      name: name,
      description: description,
      icon: icon,
      color: color,
    );

    final result = await createCategory(params);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (category) {
        _categories.insert(0, category);
        notifyListeners();
        return true;
      },
    );
  }

  /// Actualizar una categoría existente
  Future<bool> updateExistingCategory(Category category) async {
    _errorMessage = null;

    final params = UpdateCategoryParams.fromCategory(category);

    final result = await updateCategory(params);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (updatedCategory) {
        final index = _categories.indexWhere((c) => c.id == updatedCategory.id);
        if (index != -1) {
          _categories[index] = updatedCategory;
          notifyListeners();
        }
        return true;
      },
    );
  }

  /// Eliminar una categoría
  Future<bool> deleteExistingCategory(int id) async {
    _errorMessage = null;

    final result = await deleteCategory(id);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _categories.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      },
    );
  }

  /// Sincronizar categorías con el servidor
  Future<bool> syncWithServer() async {
    _errorMessage = null;

    final result = await syncCategories();

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        // Recargar categorías después de sincronizar
        loadCategories();
        return true;
      },
    );
  }

  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Buscar categorías por nombre
  List<Category> searchByName(String query) {
    if (query.isEmpty) return _categories;
    
    return _categories
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Obtener categoría por ID
  Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
