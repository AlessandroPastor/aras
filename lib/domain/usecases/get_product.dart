import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para obtener un producto por ID
class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  /// Ejecutar caso de uso
  Future<Either<Failure, Product>> call(int id) async {
    if (id <= 0) {
      return const Left(ValidationFailure('ID inválido'));
    }
    
    return await repository.getProduct(id);
  }
}
