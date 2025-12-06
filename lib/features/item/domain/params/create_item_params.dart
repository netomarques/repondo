import 'package:equatable/equatable.dart';

class CreateItemParams extends Equatable {
  final String name;
  final double quantity;
  final String category;
  final String unit;
  final String addedBy;

  const CreateItemParams({
    required this.name,
    required this.quantity,
    required this.category,
    required this.unit,
    required this.addedBy,
  });

  @override
  List<Object?> get props => [name, quantity, category, unit, addedBy];
}
