import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para actualizar una categoría
class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<Either<Failure, Category>> call(UpdateCategoryParams params) async {
    // Validar datos
    final validation = _validate(params);
    if (validation != null) {
      return Left(ValidationFailure(validation));
    }

    // Actualizar categoría
    final category = Category(
      id: params.id,
      serverId: params.serverId,
      name: params.name,
      description: params.description,
      icon: params.icon,
      color: params.color,
      isSynced: false,
      createdAt: params.createdAt,
      updatedAt: DateTime.now(),
    );

    return await repository.updateCategory(category);
  }

  String? _validate(UpdateCategoryParams params) {
    if (params.id == null || params.id! <= 0) {
      return 'ID inválido';
    }
    if (params.name.trim().isEmpty) {
      return 'El nombre de la categoría es requerido';
    }
    if (params.name.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }
}

class UpdateCategoryParams {
  final int? id;
  final int? serverId;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final DateTime createdAt;

  UpdateCategoryParams({
    required this.id,
    this.serverId,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.createdAt,
  });

  factory UpdateCategoryParams.fromCategory(Category category) {
    return UpdateCategoryParams(
      id: category.id,
      serverId: category.serverId,
      name: category.name,
      description: category.description,
      icon: category.icon,
      color: category.color,
      createdAt: category.createdAt,
    );
  }
}
