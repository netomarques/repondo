import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/domain/exports.dart';

/// Caso de uso responsável por atualizar um item.
class UpdateItemUseCase {
  final ItemRepository _repository;

  UpdateItemUseCase(this._repository);

  Future<Result<Item, ItemException>> execute({
    required UpdateItemParams params,
    required String despensaId,
  }) =>
      _repository.updateItem(params: params, despensaId: despensaId);
}
