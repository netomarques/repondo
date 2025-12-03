import 'package:equatable/equatable.dart';

class CreateItemParams extends Equatable {
  final String name;
  final String quantity;
  final String category;
  final double price;
  final String unit;
  final String addedBy;

  const CreateItemParams({
    required this.name,
    required this.quantity,
    required this.category,
    required this.price,
    required this.unit,
    required this.addedBy,
  });

  @override
  List<Object?> get props => [name, quantity, category, price, unit, addedBy];
}
