import 'package:equatable/equatable.dart';

/// Entidad de dominio para Producto
/// Esta clase es inmutable y no tiene dependencias externas
class Product extends Equatable {
  final int? id;
  final int? serverId; // ID del servidor (puede ser null si es offline)
  final String name;
  final String? description;
  final double price;
  final int stock;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
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

  /// Crear copia con campos modificados
  Product copyWith({
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
    return Product(
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
  List<Object?> get props => [
        id,
        serverId,
        name,
        description,
        price,
        stock,
        isSynced,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Product(id: $id, serverId: $serverId, name: $name, price: $price, stock: $stock, isSynced: $isSynced)';
  }
}
