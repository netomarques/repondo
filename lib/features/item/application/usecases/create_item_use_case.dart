import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/domain/exports.dart';

/// Caso de uso responsável por criar uma novo item.
class CreateItemUseCase {
  final ItemRepository _repository;

  CreateItemUseCase(this._repository);

  Future<Result<Item, ItemException>> execute({
    required CreateItemParams params,
    required String despensaId,
  }) =>
      _repository.createItem(params: params, despensaId: despensaId);
}
