import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/item/domain/exports.dart';

/// Caso de uso responsável por buscar os itens de uma despensa.
class FetchDespensaItemsUseCase {
  final ItemRepository _repository;

  FetchDespensaItemsUseCase(this._repository);

  Future<Result<List<Item>, ItemException>> fetch({
    required String despensaId,
  }) =>
      _repository.fetchDespensaItems(despensaId: despensaId);
}
