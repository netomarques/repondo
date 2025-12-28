import 'package:mockito/annotations.dart';
import 'package:repondo/features/despensa/application/facades/despensa_facade.dart';
import 'package:repondo/features/despensa/application/usecases/exports.dart';

@GenerateMocks([
  DespensaFacade,
  CreateDespensaUseCase,
  FetchDespensaUseCase,
])
void main() {}
