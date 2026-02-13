import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para sincronizar categorías
class SyncCategories {
  final CategoryRepository repository;

  SyncCategories(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.syncCategories();
  }
}
