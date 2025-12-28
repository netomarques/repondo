import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/domain/exports.dart';

abstract class ItemRepository {
  Future<Result<Item, ItemException>> createItem({
    required CreateItemParams params,
    required String despensaId,
  });

  Future<Result<List<Item>, ItemException>> fetchDespensaItems({
    required String despensaId,
  });
}
