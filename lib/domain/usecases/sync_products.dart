import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para sincronizar productos offline con el servidor
class SyncProducts {
  final ProductRepository repository;

  SyncProducts(this.repository);

  /// Ejecutar caso de uso
  Future<Either<Failure, void>> call() async {
    return await repository.syncProducts();
  }
}
