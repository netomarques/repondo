import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/domain/entities/exports.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/google_auth_notifier.dart';
import 'package:repondo/features/auth/providers/facades/google_auth_facade_provider.dart';

import '../../../../mocks/mocks.mocks.dart';

late MockGoogleAuthFacade mockGoogleAuthFacade;
late ProviderContainer container;
late UserAuth testUser;

void main() {
  group('GoogleAuthNotifier', () {
    // Setup executado antes de cada teste
    setUp(() {
      mockGoogleAuthFacade = MockGoogleAuthFacade();

      // Substitui o provider padrão pela versão mockada
      container = ProviderContainer(overrides: [
        googleAuthFacadeProvider.overrideWithValue(mockGoogleAuthFacade),
      ]);

      // Garante que o container seja descartado após o teste
      addTearDown(container.dispose);

      // Cria um usuário de teste
      testUser = UserAuth(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'http://example.com/photo.jpg',
      );

      // Configura comportamento padrão do mock
      when(mockGoogleAuthFacade.signInWithGoogle())
          .thenAnswer((_) async => testUser);
      when(mockGoogleAuthFacade.signOut()).thenAnswer((_) async {});
      when(mockGoogleAuthFacade.getCurrentUser())
          .thenAnswer((_) async => testUser);
    });

    group('build', () {
      group('casos de sucesso', () {
        test('build retorna usuário atual do facade', () async {
          // Chama o provider e aguarda o resultado da inicialização
          final result =
              await container.read(googleAuthNotifierProvider.future);

          // Verifica se o usuário retornado é o mesmo do mock
          expect(result, equals(testUser));

          // Verifica se o método do mock foi chamado uma única vez
          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });

        test('build lança AuthException se getCurrentUser retornar null',
            () async {
          // Simula que o usuário não está autenticado
          when(mockGoogleAuthFacade.getCurrentUser())
              .thenAnswer((_) async => null);

          // Verifica se a exceção correta é lançada
          await expectLater(
            container.read(googleAuthNotifierProvider.future),
            throwsA(isA<AuthException>()),
          );

          // Verifica o estado atual do provider após a falha
          final state = container.read(googleAuthNotifierProvider);
          expect(state, isA<AsyncError>());
          expect(state.error, isA<AuthException>());
          expect(state.stackTrace, isNotNull);

          // Confirma chamadas ao mock
          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });
      });

      group('casos de erro', () {
        test('build retorna erro caso falhe ao obter o usuário', () async {
          // Simula erro controlado (AuthException)
          when(mockGoogleAuthFacade.getCurrentUser())
              .thenThrow(AuthException('Erro ao obter usuário'));

          await expectLater(
            container.read(googleAuthNotifierProvider.future),
            throwsA(isA<AuthException>()),
          );

          final state = container.read(googleAuthNotifierProvider);
          expect(state, isA<AsyncError>());
          expect(state.error, isA<AuthException>());
          expect(state.stackTrace, isNotNull);

          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });

        test('build captura exceção inesperada ao obter usuário', () async {
          // Simula erro genérico (Exception)
          when(mockGoogleAuthFacade.getCurrentUser())
              .thenThrow(Exception('Erro desconhecido'));

          await expectLater(
            container.read(googleAuthNotifierProvider.future),
            throwsA(isA<Exception>()),
          );

          final state = container.read(googleAuthNotifierProvider);
          expect(state, isA<AsyncError>());
          expect((state as AsyncError).error, isA<Exception>());

          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });
      });
    });

    group('signInWithGoogle', () {
      group('casos de sucesso', () {
        test(
          'quando usuário autenticado for null signInWithGoogle emite AsyncLoading seguido de AsyncData com o usuário',
          () async {
            // Aguarda a inicialização completa do provider (necessário para garantir que está pronto para uso, build + estado inicial)
            await container.read(googleAuthNotifierProvider.future);

            // Limpa interações anteriores com o mock inicializado com build para evitar contagens erradas
            clearInteractions(mockGoogleAuthFacade);

            // Simula ausência de usuário autenticado
            when(mockGoogleAuthFacade.getCurrentUser())
                .thenAnswer((_) async => null);

            // Obtém o Notifier responsável por chamar o método a ser testado
            final notifier =
                container.read(googleAuthNotifierProvider.notifier);

            // Lista para armazenar os estados emitidos pelo provider durante a chamada
            final states = <AsyncValue<UserAuth>>[];

            // Observa o provider e registra cada mudança de estado
            final subscription = container.listen<AsyncValue<UserAuth>>(
              googleAuthNotifierProvider,
              (_, state) => states.add(state),
            );

            // Garante que o listener será cancelado após o teste
            addTearDown(subscription.close);

            // Act - Executa o método que realiza o login com Google
            await notifier.signInWithGoogle();

            // Assert - verifica que dois estados foram emitidos: carregando e sucesso
            expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
            expect(states, [
              isA<AsyncLoading>(), // Estado DURANTE o signIn
              isA<AsyncData>(), // Estado APÓS o signIn
            ]);

            // Verifica que o estado final contém o usuário esperado
            final result = notifier.state;
            expect(result, isA<AsyncData<UserAuth>>());
            expect(result.value, equals(testUser));

            // Confirma que os métodos corretos foram chamados no mock
            verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
            verify(mockGoogleAuthFacade.signInWithGoogle()).called(1);
          },
        );

        test(
          'quando usuário autenticado não for null signInWithGoogle retorna o usuário autenticado e não deve chamar signInWithGoogle do facade',
          () async {
            await container.read(googleAuthNotifierProvider.future);
            clearInteractions(mockGoogleAuthFacade);

            // Simula que o usuário já está autenticado
            when(mockGoogleAuthFacade.getCurrentUser())
                .thenAnswer((_) async => testUser);

            final notifier =
                container.read(googleAuthNotifierProvider.notifier);

            final states = <AsyncValue<UserAuth>>[];

            final subscription = container.listen<AsyncValue<UserAuth>>(
              googleAuthNotifierProvider,
              (_, state) => states.add(state),
            );

            // Clean up
            addTearDown(subscription.close);

            // Act Executa o método que deve apenas retornar o usuário já autenticado
            await notifier.signInWithGoogle();

            // Assert - Mesmo comportamento de estados: loading → data
            expect(states.length, 2);
            expect(states, [
              isA<AsyncLoading>(),
              isA<AsyncData>(),
            ]);

            final result = notifier.state;
            expect(result, isA<AsyncData<UserAuth>>());
            expect(result.value, equals(testUser));

            // Verifica que getCurrentUser foi chamado,
            // mas signInWithGoogle do facade não deve ser chamado pois o usuário já está autenticado
            verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
            verifyNever(mockGoogleAuthFacade.signInWithGoogle());
            verifyNoMoreInteractions(mockGoogleAuthFacade);
          },
        );
      });

      group('casos de erro', () {
        test(
          'signInWithGoogle emite AsyncError quando getCurrentUser lançar exceção',
          () async {
            await container.read(googleAuthNotifierProvider.future);

            clearInteractions(mockGoogleAuthFacade);

            // Simula erro interno ao tentar obter usuário atual
            when(mockGoogleAuthFacade.getCurrentUser())
                .thenThrow(Exception('Erro desconhecido'));

            final notifier =
                container.read(googleAuthNotifierProvider.notifier);

            final states = <AsyncValue<UserAuth>>[];

            final subscription = container.listen<AsyncValue<UserAuth>>(
              googleAuthNotifierProvider,
              (_, state) => states.add(state),
            );

            addTearDown(subscription.close);

            // Executa o método, que deve capturar a exceção e emitir AsyncError
            await notifier.signInWithGoogle();

            expect(states.length, 2);
            expect(states, [
              isA<AsyncLoading>(), // Estado enquanto tenta autenticar
              isA<AsyncError>(), // Estado final com erro
            ]);

            // Verifica que o erro propagado é o mesmo lançado
            final error = (states[1] as AsyncError).error;
            expect(error, isA<Exception>());

            verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
            verifyNever(mockGoogleAuthFacade.signInWithGoogle());
            verifyNoMoreInteractions(mockGoogleAuthFacade);
          },
        );
      });
    });

    group('signOut', () {
      group('casos de sucesso', () {
        test('signOut emite AsyncLoading seguido de AsyncError', () async {
          // Aguarda a inicialização completa do provider para garantir que o estado está pronto
          await container.read(googleAuthNotifierProvider.future);
          clearInteractions(mockGoogleAuthFacade);

          // Inicializa o Notifier e a lista de estados
          final notifier = container.read(googleAuthNotifierProvider.notifier);
          final states = <AsyncValue<UserAuth>>[];

          // Configura o listener para monitorar os estados emitidos pelo provider
          final subscription = container.listen<AsyncValue<UserAuth>>(
            googleAuthNotifierProvider,
            (_, state) => states.add(state),
          );

          addTearDown(subscription.close);

          // Executa o logout
          await notifier.signOut();

          // Após o logout, simula que não há usuário autenticado
          when(mockGoogleAuthFacade.getCurrentUser())
              .thenAnswer((_) async => null);

          // Aguarda o rebuild após o logout (importante para garantir que getCurrentUser foi chamado)
          await expectLater(
            () => container.read(googleAuthNotifierProvider.future),
            throwsA(isA<AuthException>()),
          );

          // Verifica os estados emitidos: AsyncLoading e AsyncError
          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading>(), // Espera o estado de carregamento
            isA<AsyncError>(), // Espera o erro após a falha
          ]);

          // Verifica a ordem correta das chamadas no mock:
          // 1. verifica se o usuário está autenticado (getCurrentUser)
          // 2. Logout é realizado
          // 3. Após o logout, o estado é reconstruído via getCurrentUser()
          verifyInOrder([
            mockGoogleAuthFacade.getCurrentUser(),
            mockGoogleAuthFacade.signOut(),
            mockGoogleAuthFacade.getCurrentUser(),
          ]);

          // Garante que nenhuma outra chamada foi feita
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });
      });

      group('casos de erros', () {
        test('signOut lança exceção AsyncError imediatamente após AsyncLoading',
            () async {
          await container.read(googleAuthNotifierProvider.future);
          clearInteractions(mockGoogleAuthFacade);

          // Simula uma falha ao tentar fazer o logout
          when(mockGoogleAuthFacade.signOut())
              .thenThrow(Exception('Erro ao deslogar'));

          final notifier = container.read(googleAuthNotifierProvider.notifier);
          final states = <AsyncValue<UserAuth>>[];

          final subscription = container.listen(
            googleAuthNotifierProvider,
            (_, state) => states.add(state),
          );

          addTearDown(subscription.close);

          await notifier.signOut();

          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading>(),
            isA<AsyncError>(),
          ]);

          final asyncError = states.last as AsyncError;
          expect(asyncError.error, isA<Exception>());
          expect((asyncError.error as Exception).toString(),
              contains('Erro ao deslogar'));

          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verify(mockGoogleAuthFacade.signOut()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });

        test(
            'deve emite AsyncErro quando getCurrentUser retornar null antes de chamar signOut',
            () async {
          await container.read(googleAuthNotifierProvider.future);
          clearInteractions(mockGoogleAuthFacade);

          final notifier = container.read(googleAuthNotifierProvider.notifier);
          final states = <AsyncValue<UserAuth>>[];

          final subscription = container.listen<AsyncValue<UserAuth>>(
            googleAuthNotifierProvider,
            (_, state) => states.add(state),
          );

          addTearDown(subscription.close);

          // Antes do logout, simula que não há usuário autenticado
          when(mockGoogleAuthFacade.getCurrentUser())
              .thenAnswer((_) async => null);

          // Executa o logout
          await notifier.signOut();

          // Verifica os estados emitidos: AsyncLoading e AsyncError
          expect(states.length, 2);
          expect(states, [
            isA<AsyncLoading>(),
            isA<AsyncError>(),
          ]);

          // Confirma que o erro foi o esperado
          final asyncError = states.last as AsyncError;
          expect(asyncError.error, isA<AuthException>());
          expect(
            (asyncError.error as AuthException).message,
            contains('Não existe mais usuário autenticado'),
          );

          // Verifica a ordem correta das chamadas no mock:
          // 1. verifica se o usuário está autenticado (getCurrentUser)
          // 2. Não chama signOut pois não há usuário autenticado
          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNever(mockGoogleAuthFacade.signOut());
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });
      });
    });
  });
}
