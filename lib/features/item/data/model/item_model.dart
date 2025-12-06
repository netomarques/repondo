import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repondo/core/mappers/firestore_mapper.dart';
import 'package:repondo/features/item/data/constants/item_firestore_keys.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/params/create_item_params.dart';

part 'item_model.freezed.dart';

@freezed
abstract class ItemModel with _$ItemModel {
  const ItemModel._();

  const factory ItemModel({
    String? id,
    required String name,
    required double quantity,
    required String category,
    required String unit,
    required String addedBy,
  }) = _ItemModel;

  factory ItemModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ItemModel(
      id: documentId,
      name: FirestoreMapper.getRequired<String>(map, ItemFirestoreKeys.name),
      quantity:
          FirestoreMapper.getRequired<double>(map, ItemFirestoreKeys.quantity),
      category:
          FirestoreMapper.getRequired<String>(map, ItemFirestoreKeys.category),
      unit: FirestoreMapper.getRequired<String>(map, ItemFirestoreKeys.unit),
      addedBy:
          FirestoreMapper.getRequired<String>(map, ItemFirestoreKeys.addedBy),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ItemFirestoreKeys.name: name,
      ItemFirestoreKeys.quantity: quantity,
      ItemFirestoreKeys.category: category,
      ItemFirestoreKeys.unit: unit,
      ItemFirestoreKeys.addedBy: addedBy,
    };
  }

  Item toEntity() {
    return Item(
      id: id!,
      name: name,
      quantity: quantity,
      category: category,
      unit: unit,
      addedBy: addedBy,
    );
  }

  factory ItemModel.fromCreateParams(CreateItemParams params) {
    return ItemModel(
      name: params.name,
      quantity: params.quantity,
      category: params.category,
      unit: params.unit,
      addedBy: params.addedBy,
    );
  }
}
