import 'package:equatable/equatable.dart';

enum AssetType { property, vehicle, crypto, stock, other }

class AssetEntity extends Equatable {
  const AssetEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.currencyCode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final AssetType type;
  final double value;
  final String currencyCode;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssetEntity copyWith({
    String? id,
    String? name,
    AssetType? type,
    double? value,
    String? currencyCode,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      currencyCode: currencyCode ?? this.currencyCode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static AssetType typeFromString(String value) {
    switch (value) {
      case 'property':
        return AssetType.property;
      case 'vehicle':
        return AssetType.vehicle;
      case 'crypto':
        return AssetType.crypto;
      case 'stock':
        return AssetType.stock;
      default:
        return AssetType.other;
    }
  }

  static String typeToString(AssetType type) {
    switch (type) {
      case AssetType.property:
        return 'property';
      case AssetType.vehicle:
        return 'vehicle';
      case AssetType.crypto:
        return 'crypto';
      case AssetType.stock:
        return 'stock';
      case AssetType.other:
        return 'other';
    }
  }

  static String typeDisplayName(AssetType type) {
    switch (type) {
      case AssetType.property:
        return 'Property';
      case AssetType.vehicle:
        return 'Vehicle';
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.stock:
        return 'Stock';
      case AssetType.other:
        return 'Other';
    }
  }

  @override
  List<Object?> get props => [
        id, name, type, value, currencyCode, notes,
        createdAt, updatedAt,
      ];
}
