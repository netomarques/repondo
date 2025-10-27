import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/application/usecases/create_despensa_use_case.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';

class DespensaFacade {
  final CreateDespensaUseCase _createDespensaUseCase;

  DespensaFacade({
    required CreateDespensaUseCase createDespensaUseCase,
  }) : _createDespensaUseCase = createDespensaUseCase;

  Future<Result<Despensa, DespensaException>> createDespensa({
    required CreateDespensaParams params,
  }) =>
      _createDespensaUseCase.execute(params: params);
}
