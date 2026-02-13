import 'package:sqflite/sqflite.dart';
import '../../../core/config/database_config.dart';
import '../../models/category_model.dart';

/// Interface abstracta para el data source local de categorías
abstract class CategoryLocalDataSource {
  Future<CategoryModel> create(CategoryModel category);
  Future<List<CategoryModel>> getAll();
  Future<CategoryModel?> getById(int id);
  Future<CategoryModel> update(CategoryModel category);
  Future<void> delete(int id);
  Future<List<CategoryModel>> getUnsyncedCategories();
  Future<void> markAsSynced(int id, int serverId);
  Future<List<CategoryModel>> searchByName(String query);
  Future<CategoryModel?> getByServerId(int serverId);
  Future<CategoryModel> upsertFromServer(CategoryModel category);
}

/// Implementación del data source local de categorías
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Database database;

  CategoryLocalDataSourceImpl(this.database);

  @override
  Future<CategoryModel> create(CategoryModel category) async {
    final id = await database.insert(
      DatabaseConfig.tableCategories,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return category.copyWith(id: id);
  }

  @override
  Future<List<CategoryModel>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConfig.tableCategories,
      where: '${DatabaseConfig.columnDeletedAt} IS NULL',
      orderBy: '${DatabaseConfig.columnName} ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<CategoryModel?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConfig.tableCategories,
      where: '${DatabaseConfig.columnId} = ? AND ${DatabaseConfig.columnDeletedAt} IS NULL',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  @override
  Future<CategoryModel> update(CategoryModel category) async {
    await database.update(
      DatabaseConfig.tableCategories,
      category.toMap(),
      where: '${DatabaseConfig.columnId} = ?',
      whereArgs: [category.id],
    );

    return category;
  }

  @override
  Future<void> delete(int id) async {
    // Soft delete
    await database.update(
      DatabaseConfig.tableCategories,
      {
        DatabaseConfig.columnDeletedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConfig.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CategoryModel>> getUnsyncedCategories() async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConfig.tableCategories,
      where: '${DatabaseConfig.columnIsSynced} = 0 AND ${DatabaseConfig.columnDeletedAt} IS NULL',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<void> markAsSynced(int id, int serverId) async {
    await database.update(
      DatabaseConfig.tableCategories,
      {
        DatabaseConfig.columnServerId: serverId,
        DatabaseConfig.columnIsSynced: 1,
      },
      where: '${DatabaseConfig.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CategoryModel>> searchByName(String query) async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConfig.tableCategories,
      where: '${DatabaseConfig.columnName} LIKE ? AND ${DatabaseConfig.columnDeletedAt} IS NULL',
      whereArgs: ['%$query%'],
      orderBy: '${DatabaseConfig.columnName} ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  /// Limpiar categorías eliminadas (hard delete)
  Future<void> purgeDeleted() async {
    await database.delete(
      DatabaseConfig.tableCategories,
      where: '${DatabaseConfig.columnDeletedAt} IS NOT NULL',
    );
  }

  /// Obtener categoría por server_id
  Future<CategoryModel?> getByServerId(int serverId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConfig.tableCategories,
      where: '${DatabaseConfig.columnServerId} = ? AND ${DatabaseConfig.columnDeletedAt} IS NULL',
      whereArgs: [serverId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  /// Actualizar o crear desde servidor
  Future<CategoryModel> upsertFromServer(CategoryModel category) async {
    if (category.serverId == null) {
      throw Exception('Category from server must have serverId');
    }

    final existing = await getByServerId(category.serverId!);

    if (existing != null) {
      // Actualizar existente
      final updated = category.copyWith(id: existing.id);
      return await update(updated);
    } else {
      // Crear nuevo
      return await create(category);
    }
  }
}
