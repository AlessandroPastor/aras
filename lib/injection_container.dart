import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

// Data
import 'data/datasources/local/database_helper.dart';
import 'data/datasources/local/product_local_datasource.dart';
import 'data/datasources/remote/product_remote_datasource.dart';
import 'data/datasources/local/category_local_datasource.dart';
import 'data/datasources/remote/category_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';

// Domain
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/usecases/create_product.dart';
import 'domain/usecases/get_products.dart';
import 'domain/usecases/get_product.dart';
import 'domain/usecases/update_product.dart';
import 'domain/usecases/delete_product.dart';
import 'domain/usecases/sync_products.dart';
import 'domain/usecases/create_category.dart';
import 'domain/usecases/get_categories.dart';
import 'domain/usecases/update_category.dart';
import 'domain/usecases/delete_category.dart';
import 'domain/usecases/sync_categories.dart';

// Presentation
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/category_provider.dart';
import 'presentation/providers/connectivity_provider.dart';

final sl = GetIt.instance; // Service Locator

/// Inicializar todas las dependencias
Future<void> initializeDependencies() async {
  // ==================== CORE ====================

  // App Config (Singleton)
  sl.registerLazySingleton(() => AppConfig());

  // HTTP Client
  sl.registerLazySingleton(() => http.Client());

  // API Client
  sl.registerLazySingleton(
    () => ApiClient(
      client: sl(),
      config: sl(),
    ),
  );

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // ==================== DATA ====================

  // Database Helper (Singleton)
  sl.registerLazySingleton(() => DatabaseHelper());

  // Data Sources - Local
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Para CategoryLocalDataSource necesitamos el database directamente
  sl.registerLazySingletonAsync<CategoryLocalDataSource>(
    () async {
      final db = await sl<DatabaseHelper>().database;
      return CategoryLocalDataSourceImpl(db);
    },
  );

  // Data Sources - Remote
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ==================== DOMAIN ====================

  // Use Cases - Products
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => SyncProducts(sl()));

  // Use Cases - Categories
  sl.registerLazySingleton(() => CreateCategory(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => SyncCategories(sl()));

  // ==================== PRESENTATION ====================

  // Providers (Factories - nueva instancia cada vez)
  sl.registerFactory(
    () => ProductProvider(
      createProductUseCase: sl(),
      getProductsUseCase: sl(),
      getProductUseCase: sl(),
      updateProductUseCase: sl(),
      deleteProductUseCase: sl(),
      syncProductsUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => CategoryProvider(
      createCategory: sl(),
      getCategories: sl(),
      updateCategory: sl(),
      deleteCategory: sl(),
      syncCategories: sl(),
    ),
  );

  sl.registerFactory(
    () => ConnectivityProvider(networkInfo: sl()),
  );
}
