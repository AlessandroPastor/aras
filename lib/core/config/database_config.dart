/// Configuración de la base de datos SQLite
class DatabaseConfig {
  // ==================== CONFIGURACIÓN GENERAL ====================
  
  /// Nombre de la base de datos
  static const String databaseName = 'aras_app.db';
  
  /// Versión actual de la base de datos
  /// IMPORTANTE: Incrementar este número cuando se hagan cambios en el esquema
  static const int databaseVersion = 2; // Incrementado para agregar categorías
  
  // ==================== TABLAS ====================
  
  /// Tabla de productos
  static const String tableProducts = 'products';
  
  /// Tabla de categorías
  static const String tableCategories = 'categories';
  
  // ==================== COLUMNAS COMUNES ====================
  
  static const String columnId = 'id';
  static const String columnServerId = 'server_id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnIsSynced = 'is_synced';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnDeletedAt = 'deleted_at';
  
  // ==================== COLUMNAS DE PRODUCTOS ====================
  
  static const String columnPrice = 'price';
  static const String columnStock = 'stock';
  
  // ==================== COLUMNAS DE CATEGORÍAS ====================
  
  static const String columnIcon = 'icon';
  static const String columnColor = 'color';
  
  // ==================== SCRIPTS DE CREACIÓN ====================
  
  /// Script para crear la tabla de productos
  static const String createProductsTable = '''
    CREATE TABLE $tableProducts (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnServerId INTEGER,
      $columnName TEXT NOT NULL,
      $columnDescription TEXT,
      $columnPrice REAL NOT NULL,
      $columnStock INTEGER NOT NULL DEFAULT 0,
      $columnIsSynced INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt TEXT NOT NULL,
      $columnUpdatedAt TEXT NOT NULL,
      $columnDeletedAt TEXT
    )
  ''';
  
  /// Script para crear la tabla de categorías
  static const String createCategoriesTable = '''
    CREATE TABLE $tableCategories (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnServerId INTEGER,
      $columnName TEXT NOT NULL,
      $columnDescription TEXT,
      $columnIcon TEXT,
      $columnColor TEXT,
      $columnIsSynced INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt TEXT NOT NULL,
      $columnUpdatedAt TEXT NOT NULL,
      $columnDeletedAt TEXT
    )
  ''';
  
  /// Índices para optimizar búsquedas
  static const List<String> createIndexes = [
    'CREATE INDEX idx_products_synced ON $tableProducts($columnIsSynced)',
    'CREATE INDEX idx_products_server_id ON $tableProducts($columnServerId)',
    'CREATE INDEX idx_products_deleted ON $tableProducts($columnDeletedAt)',
    'CREATE INDEX idx_categories_synced ON $tableCategories($columnIsSynced)',
    'CREATE INDEX idx_categories_server_id ON $tableCategories($columnServerId)',
    'CREATE INDEX idx_categories_deleted ON $tableCategories($columnDeletedAt)',
  ];
  
  // ==================== MIGRACIONES ====================
  
  /// Obtener script de migración según la versión
  static String? getMigrationScript(int oldVersion, int newVersion) {
    // Migración de versión 1 a 2: agregar tabla de categorías
    if (oldVersion == 1 && newVersion == 2) {
      return createCategoriesTable;
    }
    
    return null;
  }
  
  /// Lista de todas las tablas
  static const List<String> allTables = [
    tableProducts,
    tableCategories,
  ];
  
  // ==================== MÉTODOS DE UTILIDAD ====================
  
  /// Obtener script para eliminar todas las tablas
  static List<String> getDropAllTablesScripts() {
    return allTables.map((table) => 'DROP TABLE IF EXISTS $table').toList();
  }
  
  /// Obtener todos los scripts de creación
  static List<String> getCreateTableScripts() {
    return [
      createProductsTable,
      createCategoriesTable,
      ...createIndexes,
    ];
  }
}
