import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/sign_out_email_notifier.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import 'build_notifier_test_setup.dart';

void main() {
  group('SignOutEmailNotifier', () {
    late MockEmailAuthFacade mockEmailAuthFacade;
    late SignOutEmailNotifier notifier;
    late List<AsyncValue<void>> states;

    setUp(() async {
      // Instancia o mock da facade
      mockEmailAuthFacade = MockEmailAuthFacade();

      // Obtém o Notifier responsável por chamar o método a ser testado
      final buildContext = await buildNotifierTestContext(
        facade: mockEmailAuthFacade,
        notifierProvider: signOutEmailNotifierProvider,
        dummyResult: Success<void, AuthException>(null),
      );

      notifier = buildContext.notifier;
      states = buildContext.states;
    });

    group('signOut', () {
      group('casos de sucesso', () {
        test('signOut deve emitir AsyncLoading e AsyncData com null', () async {
          final successWithVoid = Success<void, AuthException>(null);
          // Arrange
          when(mockEmailAuthFacade.signOut())
              .thenAnswer((_) async => successWithVoid);

          // Act
          await notifier.signOut();

          // Verifica os estados emitidos: AsyncLoading seguido de AsyncData
          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading<void>>(), // Estado DURANTE o signOut
            isA<AsyncData<void>>(), // Estado APÓS o signOut
          ]);

          // Verifica chamadas no mock
          verify(mockEmailAuthFacade.signOut()).called(1);
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

          // Act: chama o método signOut
          await notifier.signOut();

          // Assert
          // Verifica estados emitidos: AsyncLoading seguido de AsyncError
          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading<void>>(), // Estado DURANTE o signOut
            isA<AsyncError<void>>(), // Estado APÓS o signOut
          ]);

          // Estado final deve ser erro com AuthException
          final state = notifier.state;
          expect(state, isA<AsyncError<void>>());
          expect(state.error, isA<AuthException>());

          // Verifica chamadas no mock
          verify(mockEmailAuthFacade.signOut()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });
    });
  });
}
