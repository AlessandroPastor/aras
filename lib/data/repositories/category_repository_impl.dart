import 'package:dartz/dartz.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/category_local_datasource.dart';
import '../datasources/remote/category_remote_datasource.dart';
import '../models/category_model.dart';

/// Implementación del repositorio de categorías
/// Maneja la lógica de offline/online y sincronización
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final CategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      
      // Guardar localmente primero
      final localCategory = await localDataSource.create(model);
      
      // Intentar sincronizar si hay conexión
      if (await networkInfo.isConnected) {
        try {
          final remoteCategory = await remoteDataSource.create(localCategory);
          await localDataSource.markAsSynced(localCategory.id!, remoteCategory.serverId!);
          return Right(remoteCategory.toEntity());
        } catch (e) {
          // Si falla la sincronización, devolver la categoría local
          return Right(localCategory.toEntity());
        }
      }
      
      return Right(localCategory.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error al crear categoría: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      // Siempre obtener de local primero
      final localCategories = await localDataSource.getAll();
      
      // Si hay conexión, sincronizar con servidor
      if (await networkInfo.isConnected) {
        try {
          final remoteCategories = await remoteDataSource.getAll();
          
          // Actualizar base de datos local con datos del servidor
          for (final remoteCategory in remoteCategories) {
            await localDataSource.upsertFromServer(remoteCategory);
          }
          
          // Devolver datos actualizados
          final updatedCategories = await localDataSource.getAll();
          return Right(updatedCategories.map((m) => m.toEntity()).toList());
        } catch (e) {
          // Si falla la sincronización, devolver datos locales
          return Right(localCategories.map((m) => m.toEntity()).toList());
        }
      }
      
      return Right(localCategories.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Error al obtener categorías: $e'));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(int id) async {
    try {
      final category = await localDataSource.getById(id);
      
      if (category == null) {
        return Left(CacheFailure('Categoría no encontrada'));
      }
      
      return Right(category.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error al obtener categoría: $e'));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      
      // Actualizar localmente
      final updatedLocal = await localDataSource.update(model);
      
      // Intentar sincronizar si hay conexión
      if (await networkInfo.isConnected && category.serverId != null) {
        try {
          final updatedRemote = await remoteDataSource.update(model);
          await localDataSource.markAsSynced(updatedLocal.id!, updatedRemote.serverId!);
          return Right(updatedRemote.toEntity());
        } catch (e) {
          // Si falla la sincronización, devolver la categoría local
          return Right(updatedLocal.toEntity());
        }
      }
      
      return Right(updatedLocal.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error al actualizar categoría: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      final category = await localDataSource.getById(id);
      
      if (category == null) {
        return Left(CacheFailure('Categoría no encontrada'));
      }
      
      // Eliminar localmente (soft delete)
      await localDataSource.delete(id);
      
      // Intentar eliminar del servidor si hay conexión y serverId
      if (await networkInfo.isConnected && category.serverId != null) {
        try {
          await remoteDataSource.delete(category.serverId!);
        } catch (e) {
          // Ignorar errores de sincronización
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al eliminar categoría: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncCategories() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Sin conexión a internet'));
      }
      
      // Obtener categorías no sincronizadas
      final unsyncedCategories = await localDataSource.getUnsyncedCategories();
      
      // Sincronizar cada categoría
      for (final category in unsyncedCategories) {
        try {
          if (category.serverId == null) {
            // Crear en servidor
            final remoteCategory = await remoteDataSource.create(category);
            await localDataSource.markAsSynced(category.id!, remoteCategory.serverId!);
          } else {
            // Actualizar en servidor
            await remoteDataSource.update(category);
            await localDataSource.markAsSynced(category.id!, category.serverId!);
          }
        } catch (e) {
          // Continuar con la siguiente categoría si falla una
          continue;
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al sincronizar categorías: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> searchCategories(String query) async {
    try {
      final categories = await localDataSource.searchByName(query);
      return Right(categories.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Error al buscar categorías: $e'));
    }
  }
}
