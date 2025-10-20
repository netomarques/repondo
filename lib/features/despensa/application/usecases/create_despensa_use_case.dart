import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:repondo/features/despensa/domain/repositories/despensa_repository.dart';

/// Caso de uso responsável por criar uma nova despensa.
class CreateDespensaUseCase {
  final DespensaRepository _repository;

  CreateDespensaUseCase(this._repository);

  Future<Result<Despensa, DespensaException>> execute({
    required CreateDespensaParams params,
  }) =>
      _repository.createDespensa(params: params);
}
