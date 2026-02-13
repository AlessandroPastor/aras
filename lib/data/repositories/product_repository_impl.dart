import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../models/product_model.dart';

/// Implementación del repositorio de productos
/// Maneja la lógica de offline/online y sincronización
class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        // MODO ONLINE: Crear en servidor y cachear localmente
        try {
          final remoteProduct = await remoteDataSource.create(productModel);
          // Guardar en caché local con serverId
          final localProduct = await localDataSource.create(
            remoteProduct.copyWith(isSynced: true),
          );
          return Right(localProduct.toEntity());
        } catch (e) {
          // Si falla el servidor, guardar offline
          final localProduct = await localDataSource.create(
            productModel.copyWith(
              isSynced: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          return Right(localProduct.toEntity());
        }
      } else {
        // MODO OFFLINE: Guardar solo localmente
        final localProduct = await localDataSource.create(
          productModel.copyWith(
            isSynced: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        return Right(localProduct.toEntity());
      }
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        // MODO ONLINE: Obtener del servidor y actualizar caché
        try {
          final remoteProducts = await remoteDataSource.getAll();
          
          // Actualizar caché local (estrategia: reemplazar todo)
          // Nota: En producción podrías usar una estrategia más sofisticada
          for (final remoteProduct in remoteProducts) {
            // Buscar si existe localmente por serverId
            final localProducts = await localDataSource.getAll();
            final existingLocal = localProducts.firstWhere(
              (p) => p.serverId == remoteProduct.serverId,
              orElse: () => remoteProduct,
            );

            if (existingLocal.id != null) {
              // Actualizar existente
              await localDataSource.update(
                remoteProduct.copyWith(
                  id: existingLocal.id,
                  isSynced: true,
                ),
              );
            } else {
              // Crear nuevo
              await localDataSource.create(
                remoteProduct.copyWith(isSynced: true),
              );
            }
          }

          // Retornar productos locales actualizados
          final localProducts = await localDataSource.getAll();
          return Right(localProducts.map((p) => p.toEntity()).toList());
        } catch (e) {
          // Si falla el servidor, retornar caché local
          final localProducts = await localDataSource.getAll();
          return Right(localProducts.map((p) => p.toEntity()).toList());
        }
      } else {
        // MODO OFFLINE: Retornar solo caché local
        final localProducts = await localDataSource.getAll();
        return Right(localProducts.map((p) => p.toEntity()).toList());
      }
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    try {
      final localProduct = await localDataSource.getById(id);
      
      if (localProduct == null) {
        return const Left(NotFoundFailure('Producto no encontrado'));
      }

      return Right(localProduct.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      if (product.id == null) {
        return const Left(ValidationFailure('El producto debe tener un ID'));
      }

      final productModel = ProductModel.fromEntity(product);
      final isConnected = await networkInfo.isConnected;

      if (isConnected && product.serverId != null) {
        // MODO ONLINE: Actualizar en servidor y localmente
        try {
          final updatedRemote = await remoteDataSource.update(
            product.serverId!,
            productModel,
          );
          
          // Actualizar local
          await localDataSource.update(
            updatedRemote.copyWith(
              id: product.id,
              isSynced: true,
            ),
          );

          final localProduct = await localDataSource.getById(product.id!);
          return Right(localProduct!.toEntity());
        } catch (e) {
          // Si falla el servidor, actualizar solo localmente
          await localDataSource.update(
            productModel.copyWith(isSynced: false),
          );
          final localProduct = await localDataSource.getById(product.id!);
          return Right(localProduct!.toEntity());
        }
      } else {
        // MODO OFFLINE: Actualizar solo localmente
        await localDataSource.update(
          productModel.copyWith(isSynced: false),
        );
        final localProduct = await localDataSource.getById(product.id!);
        return Right(localProduct!.toEntity());
      }
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      final localProduct = await localDataSource.getById(id);
      
      if (localProduct == null) {
        return const Left(NotFoundFailure('Producto no encontrado'));
      }

      final isConnected = await networkInfo.isConnected;

      if (isConnected && localProduct.serverId != null) {
        // MODO ONLINE: Eliminar del servidor y localmente
        try {
          await remoteDataSource.delete(localProduct.serverId!);
          await localDataSource.delete(id);
          return const Right(null);
        } catch (e) {
          // Si falla el servidor, marcar para eliminar después
          await localDataSource.delete(id);
          return const Right(null);
        }
      } else {
        // MODO OFFLINE: Eliminar solo localmente
        await localDataSource.delete(id);
        return const Right(null);
      }
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncProducts() async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        return const Left(NetworkFailure('No hay conexión a internet'));
      }

      // Obtener productos no sincronizados
      final unsyncedProducts = await localDataSource.getUnsyncedProducts();

      if (unsyncedProducts.isEmpty) {
        return const Right(null);
      }

      // Sincronizar cada producto
      for (final product in unsyncedProducts) {
        try {
          if (product.serverId == null) {
            // Producto nuevo: crear en servidor
            final remoteProduct = await remoteDataSource.create(product);
            // Actualizar ID local con serverId
            await localDataSource.markAsSynced(
              product.id!,
              remoteProduct.serverId!,
            );
          } else {
            // Producto existente: actualizar en servidor
            await remoteDataSource.update(product.serverId!, product);
            await localDataSource.markAsSynced(
              product.id!,
              product.serverId!,
            );
          }
        } catch (e) {
          // Continuar con el siguiente producto si uno falla
          continue;
        }
      }

      return const Right(null);
    } on NetworkFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(SyncFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      // Buscar localmente primero
      final localProducts = await localDataSource.searchByName(query);
      return Right(localProducts.map((p) => p.toEntity()).toList());
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
