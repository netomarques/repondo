import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/repositories/despensa_repository.dart';

/// Caso de uso responsável por buscar uma despensa.
class FetchDespensaUseCase {
  final DespensaRepository _repository;

  FetchDespensaUseCase(this._repository);

  Future<Result<Despensa, DespensaException>> execute({
    required String despensaId,
  }) =>
      _repository.fetchDespensaById(despensaId: despensaId);
}
