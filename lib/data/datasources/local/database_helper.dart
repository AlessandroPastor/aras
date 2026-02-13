import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/config/database_config.dart';

/// Helper singleton para gestión de la base de datos SQLite
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// Obtener instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializar base de datos
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConfig.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crear tablas en la primera ejecución
  Future<void> _onCreate(Database db, int version) async {
    // Crear tabla de productos
    await db.execute(DatabaseConfig.createProductsTable);
    
    // Crear tabla de categorías
    await db.execute(DatabaseConfig.createCategoriesTable);

    // Crear índices
    for (final indexScript in DatabaseConfig.createIndexes) {
      await db.execute(indexScript);
    }
  }

  /// Manejar actualizaciones de esquema
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Ejecutar scripts de migración si existen
    final migrationScript =
        DatabaseConfig.getMigrationScript(oldVersion, newVersion);
    if (migrationScript != null) {
      await db.execute(migrationScript);
    }
  }

  // ==================== MÉTODOS DE UTILIDAD ====================

  /// Insertar registro
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Consultar registros
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Actualizar registros
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Eliminar registros
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Ejecutar query raw
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Ejecutar comando raw
  Future<int> rawDelete(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawDelete(sql, arguments);
  }

  /// Limpiar tabla
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  /// Limpiar toda la base de datos
  Future<void> clearDatabase() async {
    for (final table in DatabaseConfig.allTables) {
      await clearTable(table);
    }
  }

  /// Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Eliminar base de datos (útil para testing)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConfig.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
