import 'package:repondo/features/item/data/constants/item_firestore_keys.dart';
import 'package:repondo/features/item/domain/params/update_item_params.dart';

class ItemUpdateFirestoreMapper {
  static Map<String, dynamic> toPartialMap(UpdateItemParams params) {
    final map = <String, dynamic>{};

    if (params.name != null) {
      map[ItemFirestoreKeys.name] = params.name;
    }
    if (params.quantity != null) {
      map[ItemFirestoreKeys.quantity] = params.quantity;
    }
    if (params.category != null) {
      map[ItemFirestoreKeys.category] = params.category;
    }
    if (params.unit != null) {
      map[ItemFirestoreKeys.unit] = params.unit;
    }

    return map;
  }
}
