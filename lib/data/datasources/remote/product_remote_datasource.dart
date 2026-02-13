import '../../models/product_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_routes.dart';

/// Interface abstracta para el data source remoto de productos
abstract class ProductRemoteDataSource {
  Future<ProductModel> create(ProductModel product);
  Future<List<ProductModel>> getAll();
  Future<ProductModel> getById(int id);
  Future<ProductModel> update(int id, ProductModel product);
  Future<void> delete(int id);
}

/// Implementación del data source remoto usando HTTP
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductModel> create(ProductModel product) async {
    final url = ApiRoutes.buildUrl(ApiRoutes.createProduct());
    final response = await apiClient.post(url, body: product.toJson());

    return ProductModel.fromJson(response);
  }

  @override
  Future<List<ProductModel>> getAll() async {
    final url = ApiRoutes.buildUrl(ApiRoutes.listProducts());
    final response = await apiClient.get(url);

    // Asumiendo que el servidor retorna: { "products": [...] } o directamente [...]
    final List<dynamic> productsJson = response['products'] ?? response['data'] ?? response;
    
    return productsJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getById(int id) async {
    final url = ApiRoutes.buildUrl(ApiRoutes.productById(id.toString()));
    final response = await apiClient.get(url);

    // Asumiendo que el servidor retorna: { "product": {...} } o directamente {...}
    final productJson = response['product'] ?? response['data'] ?? response;
    
    return ProductModel.fromJson(productJson as Map<String, dynamic>);
  }

  @override
  Future<ProductModel> update(int id, ProductModel product) async {
    final url = ApiRoutes.buildUrl(ApiRoutes.updateProduct(id.toString()));
    final response = await apiClient.put(url, body: product.toJson());

    final productJson = response['product'] ?? response['data'] ?? response;
    
    return ProductModel.fromJson(productJson as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    final url = ApiRoutes.buildUrl(ApiRoutes.deleteProduct(id.toString()));
    await apiClient.delete(url);
  }

  // ==================== MÉTODOS ADICIONALES ====================

  /// Sincronizar productos (enviar múltiples productos)
  Future<List<ProductModel>> syncProducts(List<ProductModel> products) async {
    final url = ApiRoutes.buildUrl(ApiRoutes.syncProducts());
    final response = await apiClient.post(
      url,
      body: {
        'products': products.map((p) => p.toJson()).toList(),
      },
    );

    final List<dynamic> productsJson = response['products'] ?? response['data'] ?? [];
    
    return productsJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Buscar productos
  Future<List<ProductModel>> search(String query) async {
    final url = ApiRoutes.buildUrl(
      ApiRoutes.searchProducts({'q': query}),
    );
    final response = await apiClient.get(url);

    final List<dynamic> productsJson = response['products'] ?? response['data'] ?? response;
    
    return productsJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
