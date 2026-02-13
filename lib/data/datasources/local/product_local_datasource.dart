import '../../models/product_model.dart';
import '../../../core/config/database_config.dart';
import 'database_helper.dart';

/// Interface abstracta para el data source local de productos
abstract class ProductLocalDataSource {
  Future<ProductModel> create(ProductModel product);
  Future<List<ProductModel>> getAll();
  Future<ProductModel?> getById(int id);
  Future<void> update(ProductModel product);
  Future<void> delete(int id);
  Future<List<ProductModel>> getUnsyncedProducts();
  Future<void> markAsSynced(int localId, int serverId);
  Future<void> deleteAll();
  Future<List<ProductModel>> searchByName(String query);
}

/// Implementación del data source local usando SQLite
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper databaseHelper;

  ProductLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<ProductModel> create(ProductModel product) async {
    final id = await databaseHelper.insert(
      DatabaseConfig.tableProducts,
      product.toMap(),
    );

    return product.copyWith(id: id);
  }

  @override
  Future<List<ProductModel>> getAll() async {
    final maps = await databaseHelper.query(
      DatabaseConfig.tableProducts,
      where: '${DatabaseConfig.columnDeletedAt} IS NULL',
      orderBy: '${DatabaseConfig.columnCreatedAt} DESC',
    );

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }

  @override
  Future<ProductModel?> getById(int id) async {
    final maps = await databaseHelper.query(
      DatabaseConfig.tableProducts,
      where: '${DatabaseConfig.columnId} = ? AND ${DatabaseConfig.columnDeletedAt} IS NULL',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return ProductModel.fromMap(maps.first);
  }

  @override
  Future<void> update(ProductModel product) async {
    await databaseHelper.update(
      DatabaseConfig.tableProducts,
      product.copyWith(updatedAt: DateTime.now()).toMap(),
      where: '${DatabaseConfig.columnId} = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    // Soft delete: marcar como eliminado en lugar de borrar
    await databaseHelper.update(
      DatabaseConfig.tableProducts,
      {
        DatabaseConfig.columnDeletedAt: DateTime.now().toIso8601String(),
        DatabaseConfig.columnUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConfig.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ProductModel>> getUnsyncedProducts() async {
    final maps = await databaseHelper.query(
      DatabaseConfig.tableProducts,
      where: '${DatabaseConfig.columnIsSynced} = ? AND ${DatabaseConfig.columnDeletedAt} IS NULL',
      whereArgs: [0],
      orderBy: '${DatabaseConfig.columnCreatedAt} ASC',
    );

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }

  @override
  Future<void> markAsSynced(int localId, int serverId) async {
    await databaseHelper.update(
      DatabaseConfig.tableProducts,
      {
        DatabaseConfig.columnServerId: serverId,
        DatabaseConfig.columnIsSynced: 1,
        DatabaseConfig.columnUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConfig.columnId} = ?',
      whereArgs: [localId],
    );
  }

  @override
  Future<void> deleteAll() async {
    await databaseHelper.clearTable(DatabaseConfig.tableProducts);
  }

  // ==================== MÉTODOS ADICIONALES ====================

  /// Obtener productos eliminados (para sincronización)
  Future<List<ProductModel>> getDeletedProducts() async {
    final maps = await databaseHelper.query(
      DatabaseConfig.tableProducts,
      where: '${DatabaseConfig.columnDeletedAt} IS NOT NULL AND ${DatabaseConfig.columnIsSynced} = ?',
      whereArgs: [0],
    );

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }

  /// Eliminar permanentemente productos marcados como eliminados
  Future<void> purgeDeletedProducts() async {
    await databaseHelper.delete(
      DatabaseConfig.tableProducts,
      where: '${DatabaseConfig.columnDeletedAt} IS NOT NULL',
    );
  }

  /// Buscar productos por nombre
  @override
  Future<List<ProductModel>> searchByName(String query) async {
    final maps = await databaseHelper.query(
      DatabaseConfig.tableProducts,
      where: '${DatabaseConfig.columnName} LIKE ? AND ${DatabaseConfig.columnDeletedAt} IS NULL',
      whereArgs: ['%$query%'],
      orderBy: '${DatabaseConfig.columnName} ASC',
    );

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }

  /// Contar productos
  Future<int> count() async {
    final result = await databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.tableProducts} WHERE ${DatabaseConfig.columnDeletedAt} IS NULL',
    );

    return result.first['count'] as int;
  }
}
