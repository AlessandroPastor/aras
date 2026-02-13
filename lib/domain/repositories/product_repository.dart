import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../core/error/failures.dart';

/// Interface del repositorio de productos (contrato del dominio)
abstract class ProductRepository {
  /// Crear un nuevo producto
  Future<Either<Failure, Product>> createProduct(Product product);

  /// Obtener todos los productos
  Future<Either<Failure, List<Product>>> getProducts();

  /// Obtener un producto por ID
  Future<Either<Failure, Product>> getProduct(int id);

  /// Actualizar un producto
  Future<Either<Failure, Product>> updateProduct(Product product);

  /// Eliminar un producto
  Future<Either<Failure, void>> deleteProduct(int id);

  /// Sincronizar productos offline con el servidor
  Future<Either<Failure, void>> syncProducts();

  /// Buscar productos por nombre
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
