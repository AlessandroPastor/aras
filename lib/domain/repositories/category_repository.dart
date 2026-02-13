import 'package:dartz/dartz.dart';
import '../../domain/entities/category.dart';
import '../../core/error/failures.dart';

/// Interface del repositorio de categorías (contrato del dominio)
abstract class CategoryRepository {
  /// Crear una nueva categoría
  Future<Either<Failure, Category>> createCategory(Category category);

  /// Obtener todas las categorías
  Future<Either<Failure, List<Category>>> getCategories();

  /// Obtener una categoría por ID
  Future<Either<Failure, Category>> getCategory(int id);

  /// Actualizar una categoría
  Future<Either<Failure, Category>> updateCategory(Category category);

  /// Eliminar una categoría
  Future<Either<Failure, void>> deleteCategory(int id);

  /// Sincronizar categorías offline con el servidor
  Future<Either<Failure, void>> syncCategories();

  /// Buscar categorías por nombre
  Future<Either<Failure, List<Category>>> searchCategories(String query);
}
