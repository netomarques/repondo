import 'package:equatable/equatable.dart';

class UpdateItemParams extends Equatable {
  final String itemId;
  final String? name;
  final double? quantity;
  final String? category;
  final String? unit;

  const UpdateItemParams({
    required this.itemId,
    this.name,
    this.quantity,
    this.category,
    this.unit,
  });

  @override
  List<Object?> get props => [itemId, name, quantity, category, unit];
}
