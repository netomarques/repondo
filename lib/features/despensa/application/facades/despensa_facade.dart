import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/application/usecases/exports.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';

class DespensaFacade {
  final CreateDespensaUseCase _createDespensaUseCase;
  final FetchDespensaUseCase _fetchDespensaUseCase;

  DespensaFacade({
    required CreateDespensaUseCase createDespensaUseCase,
    required FetchDespensaUseCase fetchDespensaUseCase,
  })  : _createDespensaUseCase = createDespensaUseCase,
        _fetchDespensaUseCase = fetchDespensaUseCase;

  Future<Result<Despensa, DespensaException>> createDespensa({
    required CreateDespensaParams params,
  }) =>
      _createDespensaUseCase.execute(params: params);

  Future<Result<Despensa, DespensaException>> fetchDespensa({
    required String despensaId,
  }) =>
      _fetchDespensaUseCase.execute(despensaId: despensaId);
}
