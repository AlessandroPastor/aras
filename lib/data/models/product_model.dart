import '../../domain/entities/product.dart';
import '../../core/config/database_config.dart';

/// Modelo de datos para Product con serialización JSON y SQLite
class ProductModel {
  final int? id;
  final int? serverId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    this.id,
    this.serverId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==================== CONVERSIÓN A ENTIDAD ====================

  /// Convertir modelo a entidad de dominio
  Product toEntity() {
    return Product(
      id: id,
      serverId: serverId,
      name: name,
      description: description,
      price: price,
      stock: stock,
      isSynced: isSynced,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Crear modelo desde entidad de dominio
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      serverId: product.serverId,
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      isSynced: product.isSynced,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  // ==================== SERIALIZACIÓN JSON (para API) ====================

  /// Convertir a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      if (serverId != null) 'id': serverId, // Usar serverId como id en JSON
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crear desde JSON recibido del servidor
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      serverId: json['id'] as int?, // ID del servidor
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      isSynced: true, // Si viene del servidor, está sincronizado
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  // ==================== SERIALIZACIÓN SQLITE (para base de datos local) ====================

  /// Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) DatabaseConfig.columnId: id,
      if (serverId != null) DatabaseConfig.columnServerId: serverId,
      DatabaseConfig.columnName: name,
      DatabaseConfig.columnDescription: description,
      DatabaseConfig.columnPrice: price,
      DatabaseConfig.columnStock: stock,
      DatabaseConfig.columnIsSynced: isSynced ? 1 : 0,
      DatabaseConfig.columnCreatedAt: createdAt.toIso8601String(),
      DatabaseConfig.columnUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  /// Crear desde Map de SQLite
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[DatabaseConfig.columnId] as int?,
      serverId: map[DatabaseConfig.columnServerId] as int?,
      name: map[DatabaseConfig.columnName] as String,
      description: map[DatabaseConfig.columnDescription] as String?,
      price: (map[DatabaseConfig.columnPrice] as num).toDouble(),
      stock: map[DatabaseConfig.columnStock] as int,
      isSynced: (map[DatabaseConfig.columnIsSynced] as int) == 1,
      createdAt: DateTime.parse(map[DatabaseConfig.columnCreatedAt] as String),
      updatedAt: DateTime.parse(map[DatabaseConfig.columnUpdatedAt] as String),
    );
  }

  // ==================== MÉTODOS DE UTILIDAD ====================

  /// Crear copia con campos modificados
  ProductModel copyWith({
    int? id,
    int? serverId,
    String? name,
    String? description,
    double? price,
    int? stock,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, serverId: $serverId, name: $name, price: $price, stock: $stock, isSynced: $isSynced)';
  }
}
