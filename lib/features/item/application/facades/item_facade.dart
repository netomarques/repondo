import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/application/usecases/create_item_use_case.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/exceptions/item_exception.dart';
import 'package:repondo/features/item/domain/params/create_item_params.dart';

class ItemFacade {
  final CreateItemUseCase _createItemUseCase;

  ItemFacade({
    required CreateItemUseCase createItemUseCase,
  }) : _createItemUseCase = createItemUseCase;

  Future<Result<Item, ItemException>> createItem({
    required CreateItemParams params,
    required String despensaId,
  }) =>
      _createItemUseCase.execute(params: params, despensaId: despensaId);
}
