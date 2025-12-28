import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/application/usecases/exports.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/exceptions/item_exception.dart';
import 'package:repondo/features/item/domain/params/create_item_params.dart';

class ItemFacade {
  final CreateItemUseCase _createItemUseCase;
  final FetchDespensaItemsUseCase _fetchDespensaItemsUseCase;

  ItemFacade({
    required CreateItemUseCase createItemUseCase,
    required FetchDespensaItemsUseCase fetchDespensaItemsUseCase,
  })  : _createItemUseCase = createItemUseCase,
        _fetchDespensaItemsUseCase = fetchDespensaItemsUseCase;

  Future<Result<Item, ItemException>> createItem({
    required CreateItemParams params,
    required String despensaId,
  }) =>
      _createItemUseCase.execute(params: params, despensaId: despensaId);

  Future<Result<List<Item>, ItemException>> fetchDespensaItems({
    required String despensaId,
  }) =>
      _fetchDespensaItemsUseCase.fetch(despensaId: despensaId);
}
