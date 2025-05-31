import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/exports.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';
import 'email_auth_notifier_test_setup.dart';

void main() {
  group('EmailAuthNotifier', () {
    late MockEmailAuthFacade mockEmailAuthFacade;
    late UserAuth expectedUser;
    late Success<UserAuth?, AuthException> successWithUser;
    late EmailAuthNotifier notifier;
    late List<AsyncValue<UserAuth>> states;

    setUp(() async {
      // Criação de um usuário de teste
      expectedUser = UserAuthTestFactory.create();
      successWithUser = Success<UserAuth?, AuthException>(expectedUser);

      // Instancia o mock da facade
      mockEmailAuthFacade = MockEmailAuthFacade();

      final (tempNotifier, tempStates) =
          await buildEmailAuthNotifierTestContext(mockEmailAuthFacade);

      notifier = tempNotifier;
      states = tempStates;
    });

    group('getCurrentUser', () {
      group('casos de sucesso', () {
        test('deve retornar UserAuth válido chamando getCurrentUser', () async {
          // Simula usuário autenticado
          when(mockEmailAuthFacade.getCurrentUser())
              .thenAnswer((_) async => successWithUser);

          // Act: chama o método que deve ser testado
          await notifier.getCurrentUser();

          // Assert - verifica que dois estados foram emitidos: carregando e sucesso
          expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
          expect(states, [
            isA<AsyncLoading>(), // Estado DURANTE getCurrentUser
            isA<AsyncData>(), // Estado APÓS getCurrentUser
          ]);

          // Verifica que o estado final contém o usuário esperado
          final result = notifier.state;
          expect(result, isA<AsyncData<UserAuth>>());
          expect(result.value, equals(expectedUser));

          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });

      group('casos de erro', () {
        test(
            'deve lançar AuthException chamando getCurrentUser do EmailAuthFacade quando UserAuth for null',
            () async {
          // Arrange: simula sucesso com valor nulo
          final successWithNull = Success<UserAuth?, AuthException>(null);
          when(mockEmailAuthFacade.getCurrentUser())
              .thenAnswer((_) async => successWithNull);

          // Act: chama o método que deve ser testado
          await notifier.getCurrentUser();

          // Assert - verifica que dois estados foram emitidos: carregando e AsyncError
          expect(states.length, 2); // 2 estados: AsyncLoading e AsyncError
          expect(states, [
            isA<AsyncLoading>(), // Estado DURANTE getCurrentUser
            isA<AsyncError>(), // Estado APÓS getCurrentUser
          ]);

          // Verifica que o estado do provider está em erro com AuthException
          final state = notifier.state;
          expect(state, isA<AsyncError>());
          expect(state.error, isA<AuthException>());

          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });

        test(
            'deve lançar AuthException ao chamar getCurrentUser do EmailAuthFacade e receber Failure',
            () async {
          final error = AuthException('Erro ao obter usuário');
          final failureAuth = Failure<UserAuth?, AuthException>(error);
          // Arrange: simula falha com mensagem específica
          when(mockEmailAuthFacade.getCurrentUser())
              .thenAnswer((_) async => failureAuth);

          // Act: chama o método que deve ser testado
          await notifier.getCurrentUser();

          // Assert - verifica que dois estados foram emitidos: carregando e AsyncError
          expect(states.length, 2); // 2 estados: AsyncLoading e AsyncError
          expect(states, [
            isA<AsyncLoading>(), // Estado DURANTE getCurrentUser
            isA<AsyncError>(), // Estado APÓS getCurrentUser
          ]);

          // Verifica estado de erro após falha
          final state = notifier.state;
          expect(state, isA<AsyncError>());
          expect(state.error, isA<AuthException>());

          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });
    });
  });
}
