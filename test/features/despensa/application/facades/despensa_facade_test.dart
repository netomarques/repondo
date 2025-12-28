import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/application/facades/despensa_facade.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';

import '../../mocks/despensa_mocks.mocks.dart';
import '../../mocks/despensa_test_factory.dart';

void main() {
  group('DespensaFacade', () {
    late DespensaFacade despensaFacade;
    late MockCreateDespensaUseCase mockCreateDespensaUseCase;
    late MockFetchDespensaUseCase mockFetchDespensaUseCase;

    final expectedDespensa = DespensaTestFactory.create();
    final params = CreateDespensaParams(
      name: expectedDespensa.name,
      adminIds: expectedDespensa.adminIds,
      memberIds: expectedDespensa.memberIds,
    );

    final successDespensa =
        Success<Despensa, DespensaException>(expectedDespensa);

    setUp(() {
      mockCreateDespensaUseCase = MockCreateDespensaUseCase();
      mockFetchDespensaUseCase = MockFetchDespensaUseCase();

      despensaFacade = DespensaFacade(
        createDespensaUseCase: mockCreateDespensaUseCase,
        fetchDespensaUseCase: mockFetchDespensaUseCase,
      );

      provideDummy<Result<Despensa, DespensaException>>(successDespensa);
    });

    group('casos de sucesso', () {
      test(
          'deve chamar execute() do CreateDespensaUseCase e retornar um Success<Despensa, DespensaException>',
          () async {
        // Arrange
        when(mockCreateDespensaUseCase.execute(params: anyNamed('params')))
            .thenAnswer((_) async => successDespensa);

        // Act
        final result = await despensaFacade.createDespensa(params: params);

        // Assert
        expect(result, isA<Success<Despensa, DespensaException>>());
        verify(mockCreateDespensaUseCase.execute(params: params)).called(1);
      });

      test(
          'deve chamar fetch() do FetchDespensaUseCase e retornar um Success<Despensa, DespensaException>',
          () async {
        // Arrange
        when(mockFetchDespensaUseCase.fetch(despensaId: anyNamed('despensaId')))
            .thenAnswer((_) async => successDespensa);

        // Act
        final result =
            await despensaFacade.fetchDespensa(despensaId: 'despensaId');

        // Assert
        expect(result, isA<Success<Despensa, DespensaException>>());
        verify(mockFetchDespensaUseCase.fetch(despensaId: 'despensaId'))
            .called(1);
      });
    });

    group('casos de erro', () {
      test(
          'deve chamar execute() do CreateDespensaUseCase e retornar um Failure<Despensa, DespensaException>',
          () async {
        final failureDespensa = Failure<Despensa, DespensaException>(
            DespensaException('Erro ao criar despensa'));

        // Arrange
        when(mockCreateDespensaUseCase.execute(params: anyNamed('params')))
            .thenAnswer((_) async => failureDespensa);

        // Act
        final result = await despensaFacade.createDespensa(params: params);

        // Assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        verify(mockCreateDespensaUseCase.execute(params: params)).called(1);
      });

      test(
          'deve chamar fetch() do FetchDespensaUseCase e retornar um Failure<Despensa, DespensaException>',
          () async {
        final failureDespensa = Failure<Despensa, DespensaException>(
            DespensaException('Erro ao buscar despensa'));

        // Arrange
        when(mockFetchDespensaUseCase.fetch(despensaId: anyNamed('despensaId')))
            .thenAnswer((_) async => failureDespensa);

        // Act
        final result =
            await despensaFacade.fetchDespensa(despensaId: 'despensaId');

        // Assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        verify(mockFetchDespensaUseCase.fetch(despensaId: 'despensaId'))
            .called(1);
      });
    });
  });
}
