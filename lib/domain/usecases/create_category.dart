import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para crear una categoría
class CreateCategory {
  final CategoryRepository repository;

  CreateCategory(this.repository);

  Future<Either<Failure, Category>> call(CreateCategoryParams params) async {
    // Validar datos
    final validation = _validate(params);
    if (validation != null) {
      return Left(ValidationFailure(validation));
    }

    // Crear categoría
    final category = Category(
      name: params.name,
      description: params.description,
      icon: params.icon,
      color: params.color,
      isSynced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await repository.createCategory(category);
  }

  String? _validate(CreateCategoryParams params) {
    if (params.name.trim().isEmpty) {
      return 'El nombre de la categoría es requerido';
    }
    if (params.name.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }
}

class CreateCategoryParams {
  final String name;
  final String? description;
  final String? icon;
  final String? color;

  CreateCategoryParams({
    required this.name,
    this.description,
    this.icon,
    this.color,
  });
}
