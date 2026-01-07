import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/domain/exports.dart';

/// Caso de uso responsável por deletar um item.
class DeleteItemUseCase {
  final ItemRepository _repository;

  DeleteItemUseCase(this._repository);

  Future<Result<void, ItemException>> execute({
    required String despensaId,
    required String itemId,
  }) =>
      _repository.deleteItem(despensaId: despensaId, itemId: itemId);
}
