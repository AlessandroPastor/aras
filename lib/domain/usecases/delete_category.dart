import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para eliminar una categoría
class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    if (id <= 0) {
      return Left(ValidationFailure('ID inválido'));
    }

    return await repository.deleteCategory(id);
  }
}
