import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para actualizar un producto
class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  /// Ejecutar caso de uso
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    // Validar datos
    final validation = _validate(params);
    if (validation != null) {
      return Left(ValidationFailure(validation));
    }

    // Actualizar producto
    final product = Product(
      id: params.id,
      serverId: params.serverId,
      name: params.name,
      description: params.description,
      price: params.price,
      stock: params.stock,
      isSynced: false, // Marcar como no sincronizado al actualizar
      createdAt: params.createdAt,
      updatedAt: DateTime.now(),
    );

    return await repository.updateProduct(product);
  }

  /// Validar parámetros
  String? _validate(UpdateProductParams params) {
    if (params.id == null || params.id! <= 0) {
      return 'ID inválido';
    }
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

/// Parámetros para actualizar producto
class UpdateProductParams {
  final int? id;
  final int? serverId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final DateTime createdAt;

  UpdateProductParams({
    required this.id,
    this.serverId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  /// Crear desde entidad existente
  factory UpdateProductParams.fromProduct(Product product) {
    return UpdateProductParams(
      id: product.id,
      serverId: product.serverId,
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      createdAt: product.createdAt,
    );
  }
}
