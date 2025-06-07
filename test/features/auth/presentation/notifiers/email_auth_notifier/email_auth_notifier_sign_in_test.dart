import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';
import 'email_auth_notifier_test_setup.dart';

void main() {
  group('EmailAuthNotifier', () {
    late MockEmailAuthFacade mockEmailAuthFacade;
    late UserAuth expectedUser;
    late EmailAuthNotifier notifier;
    late List<AsyncValue<UserAuth?>> states;

    setUp(() async {
      // Criação de um usuário de teste
      expectedUser = UserAuthTestFactory.create();

      // Instancia o mock da facade
      mockEmailAuthFacade = MockEmailAuthFacade();

      final (tempNotifier, tempStates) =
          await buildEmailAuthNotifierTestContext(mockEmailAuthFacade);

      notifier = tempNotifier;
      states = tempStates;
    });

    group('signInWithEmail', () {
      const email = 'example@email.com';
      const password = 'password';
      late Success<UserAuth, AuthException> success;

      setUp(() {
        success = Success<UserAuth, AuthException>(expectedUser);
        // Configuração do valor dummy para evitar MissingDummyValueError
        provideDummy<Result<UserAuth, AuthException>>(success);
      });

      group('casos de sucesso', () {
        test(
          'deve retonar UserAuth e signInWithEmail emite AsyncLoading seguido de AsyncData com o usuário',
          () async {
            // Arrange
            // Configura o mock para retornar sucesso com usuário
            when(mockEmailAuthFacade.signInWithEmail(any, any))
                .thenAnswer((_) async => success);

            // Act - Executa o método que realiza o login com email e senha
            await notifier.signInWithEmail(email: email, password: password);

            // Assert - verifica que dois estados foram emitidos: carregando e sucesso
            expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
            expect(states, [
              isA<AsyncLoading<UserAuth?>>(), // Estado DURANTE o signIn
              isA<AsyncData<UserAuth?>>(), // Estado APÓS o signIn
            ]);

            // Verifica que o estado final contém o usuário esperado
            final result = notifier.state;
            expect(result, isA<AsyncData<UserAuth?>>());
            expect(result.value, equals(expectedUser));

            // Confirma que os métodos corretos foram chamados no mock
            verify(mockEmailAuthFacade.signInWithEmail(
              email,
              password,
            )).called(1);
            verifyNoMoreInteractions(mockEmailAuthFacade);
          },
        );
      });

      group('casos de erro', () {
        test(
            'deve retornar Failure<UserAuth, AuthException> e emite AsyncLoading seguido de AsyncError quando ocorre erro',
            () async {
          // Arrange
          // Configura o mock para retornar failure com AuthException
          final failure =
              Failure<UserAuth, AuthException>(AuthException('Erro'));

          when(mockEmailAuthFacade.signInWithEmail(any, any))
              .thenAnswer((_) async => failure);

          // Act - Executa o método que realiza o login com email e senha
          await notifier.signInWithEmail(email: email, password: password);

          // Assert - verifica que dois estados foram emitidos: carregando e AsyncError
          expect(states.length, 2); // 2 estados: AsyncLoading e AsyncError
          expect(states, [
            isA<AsyncLoading<UserAuth?>>(), // Estado DURANTE o signIn
            isA<AsyncError<UserAuth?>>(), // Estado APÓS o signIn
          ]);

          // Verifica que o estado final contém o usuário esperado
          final result = notifier.state;
          expect(result, isA<AsyncError<UserAuth?>>());
          expect(result.error, isA<AuthException>());

          // Confirma que os métodos corretos foram chamados no mock
          verify(mockEmailAuthFacade.signInWithEmail(
            email,
            password,
          )).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });
    });
  });
}
