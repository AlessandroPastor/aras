import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para obtener todos los productos
class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  /// Ejecutar caso de uso
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
