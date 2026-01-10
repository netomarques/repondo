import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/application/usecases/exports.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/exceptions/item_exception.dart';
import 'package:repondo/features/item/domain/params/create_item_params.dart';
import 'package:repondo/features/item/domain/params/update_item_params.dart';

class ItemFacade {
  final CreateItemUseCase _createItemUseCase;
  final FetchDespensaItemsUseCase _fetchDespensaItemsUseCase;
  final DeleteItemUseCase _deleteItemUseCase;
  final UpdateItemUseCase _updateItemUseCase;

  ItemFacade({
    required CreateItemUseCase createItemUseCase,
    required FetchDespensaItemsUseCase fetchDespensaItemsUseCase,
    required DeleteItemUseCase deleteItemUseCase,
    required UpdateItemUseCase updateItemUseCase,
  })  : _createItemUseCase = createItemUseCase,
        _fetchDespensaItemsUseCase = fetchDespensaItemsUseCase,
        _deleteItemUseCase = deleteItemUseCase,
        _updateItemUseCase = updateItemUseCase;

  Future<Result<Item, ItemException>> createItem({
    required CreateItemParams params,
    required String despensaId,
  }) =>
      _createItemUseCase.execute(params: params, despensaId: despensaId);

  Future<Result<List<Item>, ItemException>> fetchDespensaItems({
    required String despensaId,
  }) =>
      _fetchDespensaItemsUseCase.fetch(despensaId: despensaId);

  Future<Result<void, ItemException>> deleteItem({
    required String despensaId,
    required String itemId,
  }) =>
      _deleteItemUseCase.execute(despensaId: despensaId, itemId: itemId);

  Future<Result<Item, ItemException>> updateItem({
    required UpdateItemParams params,
    required String despensaId,
  }) =>
      _updateItemUseCase.execute(params: params, despensaId: despensaId);
}
