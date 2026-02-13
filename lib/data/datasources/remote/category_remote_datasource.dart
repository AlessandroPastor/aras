import '../../../core/network/api_client.dart';
import '../../../core/config/api_routes.dart';
import '../../models/category_model.dart';

/// Interface abstracta para el data source remoto de categorías
abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAll();
  Future<CategoryModel> getById(int id);
  Future<CategoryModel> create(CategoryModel category);
  Future<CategoryModel> update(CategoryModel category);
  Future<void> delete(int id);
}

/// Implementación del data source remoto de categorías
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CategoryModel>> getAll() async {
    final response = await apiClient.get(ApiRoutes.categories);
    final List<dynamic> data = response['data'] ?? response;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryModel> getById(int id) async {
    final response = await apiClient.get(ApiRoutes.categoryById(id.toString()));
    final data = response['data'] ?? response;
    return CategoryModel.fromJson(data);
  }

  @override
  Future<CategoryModel> create(CategoryModel category) async {
    final response = await apiClient.post(
      ApiRoutes.createCategory(),
      body: category.toJson(),
    );
    final data = response['data'] ?? response;
    return CategoryModel.fromJson(data);
  }

  @override
  Future<CategoryModel> update(CategoryModel category) async {
    if (category.serverId == null) {
      throw Exception('Category must have serverId to update on server');
    }

    final response = await apiClient.put(
      ApiRoutes.updateCategory(category.serverId.toString()),
      body: category.toJson(),
    );
    final data = response['data'] ?? response;
    return CategoryModel.fromJson(data);
  }

  @override
  Future<void> delete(int id) async {
    await apiClient.delete(ApiRoutes.deleteCategory(id.toString()));
  }
}
