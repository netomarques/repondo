import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final double quantity;
  final String category;
  final String unit;
  final String addedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.unit,
    required this.addedBy,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, name, quantity, category, unit, addedBy, createdAt, updatedAt];
}
