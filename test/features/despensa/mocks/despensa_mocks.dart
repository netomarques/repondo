import 'package:mockito/annotations.dart';
import 'package:repondo/features/despensa/application/facades/despensa_facade.dart';
import 'package:repondo/features/despensa/application/usecases/create_despensa_use_case.dart';

@GenerateMocks([
  DespensaFacade,
  CreateDespensaUseCase,
])
void main() {}
