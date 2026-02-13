import 'package:equatable/equatable.dart';

/// Entidad de dominio para Categoría
class Category extends Equatable {
  final int? id;
  final int? serverId;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
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

  @override
  List<Object?> get props => [
        id,
        serverId,
        name,
        description,
        icon,
        color,
        isSynced,
        createdAt,
        updatedAt,
      ];

  /// Crear copia con campos modificados
  Category copyWith({
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
    return Category(
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
}
