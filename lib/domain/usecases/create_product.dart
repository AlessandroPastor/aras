import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para crear un producto
class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  /// Ejecutar caso de uso
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    // Validar datos
    final validation = _validate(params);
    if (validation != null) {
      return Left(ValidationFailure(validation));
    }

    // Crear producto
    final product = Product(
      name: params.name,
      description: params.description,
      price: params.price,
      stock: params.stock,
      isSynced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await repository.createProduct(product);
  }

  /// Validar parámetros
  String? _validate(CreateProductParams params) {
    if (params.name.trim().isEmpty) {
      return 'El nombre del producto es requerido';
    }
    if (params.name.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    if (params.price <= 0) {
      return 'El precio debe ser mayor a 0';
    }
    if (params.stock < 0) {
      return 'El stock no puede ser negativo';
    }
    return null;
  }
}

/// Parámetros para crear producto
class CreateProductParams {
  final String name;
  final String? description;
  final double price;
  final int stock;

  CreateProductParams({
    required this.name,
    this.description,
    required this.price,
    required this.stock,
  });
}
