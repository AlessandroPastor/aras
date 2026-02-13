import '../../domain/entities/category.dart';
import '../../core/config/database_config.dart';

/// Modelo de datos para Category con serialización JSON y SQLite
class CategoryModel {
  final int? id;
  final int? serverId;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    this.id,
    this.serverId,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==================== CONVERSIÓN A ENTIDAD ====================

  /// Convertir modelo a entidad de dominio
  Category toEntity() {
    return Category(
      id: id,
      serverId: serverId,
      name: name,
      description: description,
      icon: icon,
      color: color,
      isSynced: isSynced,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Crear modelo desde entidad de dominio
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      serverId: category.serverId,
      name: category.name,
      description: category.description,
      icon: category.icon,
      color: category.color,
      isSynced: category.isSynced,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  // ==================== SERIALIZACIÓN JSON (para API) ====================

  /// Convertir a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      if (serverId != null) 'id': serverId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crear desde JSON recibido del servidor
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      serverId: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isSynced: true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  // ==================== SERIALIZACIÓN SQLITE ====================

  /// Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crear desde Map de SQLite
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      serverId: map['server_id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
      color: map['color'] as String?,
      isSynced: (map['is_synced'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  // ==================== MÉTODOS DE UTILIDAD ====================

  /// Crear copia con campos modificados
  CategoryModel copyWith({
    int? id,
    int? serverId,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, serverId: $serverId, name: $name, isSynced: $isSynced)';
  }
}
