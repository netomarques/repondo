import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String quantity;
  final String category;
  final double price;
  final String unit;
  final DateTime lastPurchase;
  final String addedBy;

  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.price,
    required this.unit,
    required this.lastPurchase,
    required this.addedBy,
  });

  @override
  List<Object?> get props =>
      [id, name, quantity, category, price, unit, lastPurchase, addedBy];
}
