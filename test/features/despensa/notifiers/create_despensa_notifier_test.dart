import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:repondo/features/despensa/presentation/notifiers/create_despensa_notifier.dart';

import '../mocks/despensa_mocks.mocks.dart';
import '../mocks/despensa_test_factory.dart';
import 'build_despensa_notifier_test_setup.dart';

void main() {
  group('CreateDespensaNotifier', () {
    late MockDespensaFacade mockDespensaFacade;
    late Despensa expectedDespensa;
    late CreateDespensaNotifier notifier;
    late List<AsyncValue<Despensa?>> states;
    late Success<Despensa, DespensaException> successWithDespensa;
    late CreateDespensaParams createParams;

    setUp(() async {
      expectedDespensa = DespensaTestFactory.create();
      createParams = CreateDespensaParams(
        name: expectedDespensa.name,
        adminIds: expectedDespensa.adminIds,
        memberIds: expectedDespensa.memberIds,
      );

      // Configuração do valor dummy para evitar MissingDummyValueError
      successWithDespensa =
          Success<Despensa, DespensaException>(expectedDespensa);
      provideDummy<Result<Despensa, DespensaException>>(successWithDespensa);

      // Instancia o mock da facade
      mockDespensaFacade = MockDespensaFacade();

      // Obtém o Notifier responsável por chamar o método a ser testado
      final buildContext = await buildDespensaNotifierTestContext(
        facade: mockDespensaFacade,
        notifierProvider: createDespensaNotifierProvider,
        dummyResult: Success<Despensa?, DespensaException>(null),
      );

      notifier = buildContext.notifier;
      states = buildContext.states;
    });

    group('casos de sucesso', () {
      test(
          'deve retornar uma Despensa quando emitir AsyncLoading e AsyncData com a despensa',
          () async {
        // Arrange
        // Configura o mock para retornar sucesso com despensa
        when(mockDespensaFacade.createDespensa(params: anyNamed('params')))
            .thenAnswer((_) async => successWithDespensa);

        // Act - Executa o método que cria a despensa
        await notifier.createDespensa(createParams);

        // Assert - verifica que dois estados foram emitidos: carregando e sucesso
        expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
        expect(states, [
          isA<AsyncLoading<Despensa?>>(),
          isA<AsyncData<Despensa?>>(),
        ]);

        // Verifica que o estado final contém a despensa esperada
        final result = notifier.state;
        expect(result, isA<AsyncData<Despensa?>>());
        expect(result.value, equals(expectedDespensa));

        // Confirma que os métodos corretos foram chamados no mock
        verify(mockDespensaFacade.createDespensa(
          params: createParams,
        )).called(1);
        verifyNoMoreInteractions(mockDespensaFacade);
      });
    });

    group('casos de erro', () {
      test(
          'deve retornar Failure<Despensa, DespensaException> e emitir AsyncLoading seguido de AsyncError quando ocorrer um erro',
          () async {
        // Arrange
        // Configura o mock para retornar failure com DespensaException
        final failure = Failure<Despensa, DespensaException>(
            DespensaException('Erro ao criar despensa'));

        when(mockDespensaFacade.createDespensa(params: anyNamed('params')))
            .thenAnswer((_) async => failure);

        // Act - Executa o método que cria a despensa
        await notifier.createDespensa(createParams);

        // Assert - verifica que dois estados foram emitidos: AsyncLoading e AsyncError
        expect(states.length, 2); // 2 estados: AsyncLoading e AsyncError
        expect(states, [
          isA<AsyncLoading<Despensa?>>(),
          isA<AsyncError<Despensa?>>(),
        ]);

        // Verifica que o estado final contém o erro esperado
        final result = notifier.state;
        expect(result, isA<AsyncError<Despensa?>>());
        expect(result.error, equals(isA<DespensaException>()));

        // Confirma que os métodos corretos foram chamados no mock
        verify(mockDespensaFacade.createDespensa(
          params: createParams,
        )).called(1);
        verifyNoMoreInteractions(mockDespensaFacade);
      });
    });
  });
}
