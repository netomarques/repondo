import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/sign_up_email_notifier.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';
import 'build_notifier_test_setup.dart';

void main() {
  group('SignUpEmailNotifier', () {
    late MockEmailAuthFacade mockEmailAuthFacade;
    late UserAuth expectedUser;
    late SignUpEmailNotifier notifier;
    late List<AsyncValue<UserAuth?>> states;
    late Success<UserAuth, AuthException> successWithUser;

    setUp(() async {
      // Criação de um usuário de teste
      expectedUser = UserAuthTestFactory.create();

      // Configuração do valor dummy para evitar MissingDummyValueError
      successWithUser = Success<UserAuth, AuthException>(expectedUser);
      provideDummy<Result<UserAuth, AuthException>>(successWithUser);

      // Instancia o mock da facade
      mockEmailAuthFacade = MockEmailAuthFacade();

      // Obtém o Notifier responsável por chamar o método a ser testado
      final buildContext = await buildNotifierTestContext(
          facade: mockEmailAuthFacade,
          notifierProvider: signUpEmailNotifierProvider,
          dummyResult: Success<UserAuth?, AuthException>(null));

      notifier = buildContext.notifier;
      states = buildContext.states;
    });

    group('signUpWithEmail', () {
      const email = 'example@email.com';
      const password = 'password';

      group('casos de sucesso', () {
        test(
            'deve retonar UserAuth e signUpWithEmail emite AsyncLoading seguido de AsyncData',
            () async {
          // Arrange: configura o mock para retornar sucesso
          when(mockEmailAuthFacade.signUpWithEmail(any, any))
              .thenAnswer((_) async => successWithUser);

          // Act: chama o método signUpWithEmail
          await notifier.signUpWithEmail(email: email, password: password);

          // Assert - verifica que dois estados foram emitidos: carregando e sucesso
          expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
          expect(states, [
            isA<AsyncLoading<UserAuth?>>(), // Estado DURANTE o signUp
            isA<AsyncData<UserAuth?>>(), // Estado APÓS o signUp
          ]);

          // Verifica que o estado final contém o usuário esperado
          final result = notifier.state;
          expect(result, isA<AsyncData<UserAuth?>>());
          expect(result.value, equals(expectedUser));

          // Confirma que os métodos corretos foram chamados no mock
          verify(mockEmailAuthFacade.signUpWithEmail(
            email,
            password,
          )).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });

      group('casos de erro', () {
        test(
            'deve retornar Failure<UserAuth, AuthException> e signUpWithEmail emite AsyncLoading seguido de AsyncError quando ocorre erro',
            () async {
          // Arrange: simula um erro ao tentar realizar o signUp
          final failure =
              Failure<UserAuth, AuthException>(AuthException('Erro'));

          when(mockEmailAuthFacade.signUpWithEmail(any, any))
              .thenAnswer((_) async => failure);

          // Act: chama o método signUpWithEmail
          await notifier.signUpWithEmail(email: email, password: password);

          // Assert - verifica que dois estados foram emitidos: carregando e AsyncError
          expect(states.length, 2); // 2 estados: AsyncLoading e AsyncError
          expect(states, [
            isA<AsyncLoading<UserAuth?>>(), // Estado DURANTE o signUp
            isA<AsyncError<UserAuth?>>(), // Estado APÓS o signUp
          ]);

          // Verifica que o estado final contém o usuário esperado
          final result = notifier.state;
          expect(result, isA<AsyncError<UserAuth?>>());
          expect(result.error, isA<AuthException>());

          // Confirma que os métodos corretos foram chamados no mock
          verify(mockEmailAuthFacade.signUpWithEmail(
            email,
            password,
          )).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });
    });
  });
}
