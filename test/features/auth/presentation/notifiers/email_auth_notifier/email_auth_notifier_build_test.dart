import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/exports.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier.dart';
import 'package:repondo/features/auth/providers/facades/email_auth_facade_provider.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';

void main() {
  group('EmailAuthNotifier', () {
    late MockEmailAuthFacade mockEmailAuthFacade;
    late ProviderContainer container;
    late UserAuth expectedUser;

    setUp(() {
      // Criação de um usuário de teste
      expectedUser = UserAuthTestFactory.create();
      final successWithUser = Success<UserAuth?, AuthException>(expectedUser);

      // Instancia o mock da facade
      mockEmailAuthFacade = MockEmailAuthFacade();

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<UserAuth?, AuthException>>(successWithUser);

      // Configura o mock para retornar sucesso com usuário
      when(mockEmailAuthFacade.getCurrentUser())
          .thenAnswer((_) async => successWithUser);

      // Cria um container com a dependência substituída pelo mock
      container = ProviderContainer(overrides: [
        emailAuthFacadeProvider.overrideWithValue(mockEmailAuthFacade),
      ]);

      // Garante que o container será fechado após os testes
      addTearDown(container.dispose);
    });

    group('build', () {
      group('casos de sucesso', () {
        test(
            'deve retornar UserAuth válido chamando getCurrentUser do EmailAuthFacade quando UserAuth não for null',
            () async {
          // Act
          final result = await container.read(emailAuthNotifierProvider.future);

          // Assert
          expect(result, isA<UserAuth?>());
          expect(result, isNotNull);
          expect(result, expectedUser);
          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });

        test(
            'deve retornar UserAuth null chamando getCurrentUser do EmailAuthFacade quando UserAuth for null',
            () async {
          final successWithNull = Success<UserAuth?, AuthException>(null);

          // Arrange: simula retorno de usuário nulo
          when(mockEmailAuthFacade.getCurrentUser())
              .thenAnswer((_) async => successWithNull);

          // Act
          final result = await container.read(emailAuthNotifierProvider.future);

          // Assert
          expect(result, isA<UserAuth?>());
          expect(result, isNull);
          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });

      group('casos de erro', () {
        test(
            'deve lançar AuthException chamando getCurrentUser do EmailAuthFacade retornar erro',
            () async {
          final error = AuthException('Erro ao obter usuário');
          final failureAuth = Failure<UserAuth?, AuthException>(error);

          // Arrange: simula falha com mensagem específica
          when(mockEmailAuthFacade.getCurrentUser())
              .thenAnswer((_) async => failureAuth);

          // Act + Assert: espera que a exceção seja lançada com a mensagem correta
          await expectLater(
            container.read(emailAuthNotifierProvider.future),
            throwsA(isA<AuthException>().having((e) => e.message, 'mensagem',
                contains('Erro ao obter usuário'))),
          );

          // Verifica estado de erro após falha
          final state = container.read(emailAuthNotifierProvider);
          expect(state, isA<AsyncError>());
          expect(state.error, isA<AuthException>());

          verify(mockEmailAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockEmailAuthFacade);
        });
      });
    });
  });
}
