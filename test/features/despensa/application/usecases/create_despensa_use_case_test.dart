import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/application/usecases/create_despensa_use_case.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';

import '../../mocks/despensa_test_factory.dart';
import '../../mocks/firebase_despensa_repository_mocks.mocks.dart';

void main() {
  group('CreateDespensaUseCase', () {
    late CreateDespensaUseCase useCase;
    late MockDespensaRepository mockDespensaRepository;
    late Despensa expectedDespensa;
    late CreateDespensaParams params;

    setUp(() {
      mockDespensaRepository = MockDespensaRepository();
      expectedDespensa = DespensaTestFactory.create();
      useCase = CreateDespensaUseCase(mockDespensaRepository);
      params = CreateDespensaParams(
        name: expectedDespensa.name,
        adminIds: expectedDespensa.adminIds,
        memberIds: expectedDespensa.memberIds,
      );

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<Despensa, DespensaException>>(
        Success(expectedDespensa),
      );
    });

    group('casos de sucesso', () {
      test(
          'deve chamar createDespensa e retornar um Success<Despensa, DespensaException> ',
          () async {
        // Arrange
        when(mockDespensaRepository.createDespensa(params: anyNamed('params')))
            .thenAnswer((_) async => Success(expectedDespensa));

        // Act
        final result = await useCase.execute(params: params);

        // Assert
        expect(result, isA<Success<Despensa, DespensaException>>());
        final despensa = result.data!;
        expect(despensa.id, expectedDespensa.id);

        verify(mockDespensaRepository.createDespensa(params: params)).called(1);
        verifyNoMoreInteractions(mockDespensaRepository);
      });
    });

    group('casos de falha', () {
      test(
          'deve retornar um Failure<Despensa, DespensaException> quando createDespensa falhar',
          () async {
        // Arrange
        final exception = DespensaException('Erro ao criar despensa');
        when(mockDespensaRepository.createDespensa(params: anyNamed('params')))
            .thenAnswer((_) async => Failure(exception));

        // Act
        final result = await useCase.execute(params: params);

        // Assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error.message, exception.message);

        verify(mockDespensaRepository.createDespensa(params: params)).called(1);
        verifyNoMoreInteractions(mockDespensaRepository);
      });
    });
  });
}
