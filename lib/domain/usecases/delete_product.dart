import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para eliminar un producto
class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  /// Ejecutar caso de uso
  Future<Either<Failure, void>> call(int id) async {
    if (id <= 0) {
      return const Left(ValidationFailure('ID inválido'));
    }
    
    return await repository.deleteProduct(id);
  }
}
