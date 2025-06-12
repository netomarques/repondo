import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';

class _CounterBuildEmailAuthNotifier extends EmailAuthNotifier {
  int buildCount = 0;

  @override
  Future<UserAuth?> build() async {
    buildCount++;
    return super.build();
  }
}

Future<
    (
      EmailAuthNotifier notifier,
      List<AsyncValue<UserAuth?>> states,
      ProviderContainer container,
      _CounterBuildEmailAuthNotifier counterBuildNotifier,
    )> _buildEmailAuthNotifierTest(MockEmailAuthFacade facade) async {
  // Criação de um usuário de teste
  final expectedUser = UserAuthTestFactory.create();
  final result = Success<UserAuth?, AuthException>(expectedUser);

  // Configuração do valor dummy para evitar MissingDummyValueError
  provideDummy<Result<UserAuth?, AuthException>>(result);

  // Configura o mock para retornar sucesso com usuário
  when(facade.getCurrentUser()).thenAnswer((_) async => result);

  // Instancia a subclasse do Notifier que conta quantos builds ocorreram
  final counterBuildNotifier = _CounterBuildEmailAuthNotifier();

  // Cria um container com a dependência substituída pelo mock
  final container = ProviderContainer(overrides: [
    emailAuthFacadeProvider.overrideWithValue(facade),
    emailAuthNotifierProvider.overrideWith(() => counterBuildNotifier),
  ]);

  // Garante que o container será fechado após os testes
  addTearDown(container.dispose);

  // Aguarda a inicialização completa do provider (necessário para garantir que está pronto para uso, build + estado inicial)
  await container.read(emailAuthNotifierProvider.future);

  // Limpa interações anteriores com o mock inicializado com build para evitar contagens erradas
  clearInteractions(facade);

  // Obtém o Notifier responsável por chamar o método a ser testado
  final notifier = container.read(emailAuthNotifierProvider.notifier);

  // Lista para armazenar os estados emitidos pelo provider durante a chamada
  final states = <AsyncValue<UserAuth?>>[];

  // Observa o provider e registra cada mudança de estado
  final subscription = container.listen<AsyncValue<UserAuth?>>(
    emailAuthNotifierProvider,
    (_, state) => states.add(state),
  );

  // Garante que o listener será cancelado após o teste
  addTearDown(subscription.close);

  // Retorna o notifier, states
  // para que possam ser utilizados nos testes
  return (notifier, states, container, counterBuildNotifier);
}

void main() {
  group('EmailAuthNotifier', () {
    late MockEmailAuthFacade mockEmailAuthFacade;
    late EmailAuthNotifier notifier;
    late List<AsyncValue<UserAuth?>> states;
    late ProviderContainer container;
    late _CounterBuildEmailAuthNotifier counterBuildNotifier;

    setUp(() async {
      // Instancia o mock da facade
      mockEmailAuthFacade = MockEmailAuthFacade();

      final (tempNotifier, tempStates, tempContainer, tempCouterBuildNotifier) =
          await _buildEmailAuthNotifierTest(mockEmailAuthFacade);

      notifier = tempNotifier;
      states = tempStates;
      container = tempContainer;
      counterBuildNotifier = tempCouterBuildNotifier;
    });

    group('signOut', () {
      late Success<void, AuthException> successWithVoid;

      setUp(() {
        // Evita erro de tipo em mocks com Result<void>
        successWithVoid = Success<void, AuthException>(null);
        // Configuração do valor dummy para evitar MissingDummyValueError
        provideDummy<Result<void, AuthException>>(successWithVoid);
      });

      group('casos de sucesso', () {
        test(
            'signOut deve emitir AsyncLoading, chamar build novamente e retorna UserAuth null',
            () async {
          final successWithNull = Success<UserAuth?, AuthException>(null);

          // Arrange
          // Configura o mock para que signOut() retorne sucesso
          when(mockEmailAuthFacade.signOut())
              .thenAnswer((_) async => successWithVoid);

          // Verifica o estado inicial: apenas um build foi feito
          expect(counterBuildNotifier.buildCount, 1);

          // Act
          // Executa o signOut
          await notifier.signOut();

          // simula a resposta do getCurrentUser como null
          when(mockEmailAuthFacade.getCurrentUser())
              .thenAnswer((_) async => successWithNull);

          // Aguarda rebuild e retorna UserAuth null
          await expectLater(
            container.read(emailAuthNotifierProvider.future),
            isA<Future<UserAuth?>>(),
          );

          // Assert
          // Deve ter ocorrido um novo build após o signOut
          expect(counterBuildNotifier.buildCount, 2);

          // Verifica os estados emitidos: AsyncLoading seguido de AsyncData
          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading<UserAuth?>>(), // Estado DURANTE o signOut
            isA<AsyncData<UserAuth?>>(), // Estado APÓS o signOut
          ]);

          // Confirma que o estado final é AsyncData com UserAuth null
          final state = notifier.state;
          expect(state, isA<AsyncData<UserAuth?>>());
          expect(state.value, isNull);

          // Verifica chamadas no mock
          verify(mockEmailAuthFacade.signOut()).called(1);
          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });

      group('casos de erro', () {
        test(
            'signOut deve emitir AsyncLoading e em seguida AsyncError quando falhar',
            () async {
          final error = AuthException('Erro ao fazer sign out');
          final failure = Failure<void, AuthException>(error);

          // Arrange: configura o mock para retornar falha
          when(mockEmailAuthFacade.signOut()).thenAnswer((_) async => failure);

          // Build inicial deve ter sido executado uma única vez
          expect(counterBuildNotifier.buildCount, 1);

          // Act: chama o método signOut
          await notifier.signOut();

          // Assert

          // build não deve ser chamado novamente após falha no signOut
          expect(counterBuildNotifier.buildCount, 1);

          // Verifica estados emitidos: AsyncLoading seguido de AsyncError
          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading<UserAuth?>>(), // Estado DURANTE o signOut
            isA<AsyncError<UserAuth?>>(), // Estado APÓS o signOut
          ]);

          // Estado final deve ser erro com AuthException
          final state = notifier.state;
          expect(state, isA<AsyncError<UserAuth?>>());
          expect(state.error, isA<AuthException>());

          // Verifica chamadas no mock
          verify(mockEmailAuthFacade.signOut()).called(1);
          verifyNever(mockEmailAuthFacade.getCurrentUser());
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });
    });
  });
}
