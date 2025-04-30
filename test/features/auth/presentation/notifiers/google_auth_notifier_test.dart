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
    setUp(() {
      mockGoogleAuthFacade = MockGoogleAuthFacade();
      container = ProviderContainer(overrides: [
        googleAuthFacadeProvider.overrideWithValue(mockGoogleAuthFacade),
      ]);

      addTearDown(container.dispose);

      testUser = UserAuth(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'http://example.com/photo.jpg',
      );

      when(mockGoogleAuthFacade.signInWithGoogle())
          .thenAnswer((_) async => testUser);
      when(mockGoogleAuthFacade.signOut()).thenAnswer((_) async {});
      when(mockGoogleAuthFacade.getCurrentUser())
          .thenAnswer((_) async => testUser);
    });

    group('build', () {
      group('casos de sucesso', () {
        test('build retorna usuário atual do facade', () async {
          final result =
              await container.read(googleAuthNotifierProvider.future);

          expect(result, equals(testUser));
          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });
      });

      group('casos de erro', () {
        test('build retorna erro caso falhe ao obter o usuário', () async {
          // Configura o mock para lançar uma exceção ao buscar o usuário
          when(mockGoogleAuthFacade.getCurrentUser())
              .thenThrow(AuthException('Erro ao obter usuário'));

          // Usa expectLater para capturar o estado assíncrono
          await expectLater(
            container.read(googleAuthNotifierProvider.future),
            throwsA(isA<AuthException>()),
          );

          // Verifica o estado após o erro
          final state = container.read(googleAuthNotifierProvider);
          expect(state, isA<AsyncError>());
          expect(state.error, isA<AuthException>());
          expect(state.stackTrace, isNotNull);

          verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
          verifyNoMoreInteractions(mockGoogleAuthFacade);
        });

        test('build captura exceção inesperada ao obter usuário', () async {
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
      setUp(() async {
        // 1. Aguarda a inicialização COMPLETA (build + estado inicial)
        await container.read(googleAuthNotifierProvider.future);

        // Limpa histórico do mock para ignorar interações iniciais
        clearInteractions(mockGoogleAuthFacade);

        when(mockGoogleAuthFacade.getCurrentUser())
            .thenThrow(AuthException('Usuário autenticado é null'));
      });

      group('casos de sucesso', () {
        test(
          'quando usuário autenticado for null signInWithGoogle emite AsyncLoading seguido de AsyncData com o usuário',
          () async {
            final notifier =
                container.read(googleAuthNotifierProvider.notifier);

            final states = <AsyncValue<UserAuth>>[];

            final subscription = container.listen<AsyncValue<UserAuth>>(
              googleAuthNotifierProvider,
              (_, state) => states.add(state),
            );

            // Clean up
            addTearDown(subscription.close);

            // Act
            await notifier.signInWithGoogle();

            // Assert - APENAS os estados do signIn
            expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
            expect(states, [
              isA<AsyncLoading>(), // Estado DURANTE o signIn
              isA<AsyncData>(), // Estado APÓS o signIn
            ]);

            final result = notifier.state;
            expect(result, isA<AsyncData<UserAuth>>());
            expect(result.value, equals(testUser));

            verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
            verify(mockGoogleAuthFacade.signInWithGoogle()).called(1);
          },
        );

        test(
          'quando usuário autenticado não for null signInWithGoogle retorna o usuário autenticado e não deve chamar signInWithGoogle do facade',
          () async {
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

            // Act
            await notifier.signInWithGoogle();

            // Assert - APENAS os estados do signIn
            expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
            expect(states, [
              isA<AsyncLoading>(), // Estado DURANTE o signIn
              isA<AsyncData>(), // Estado APÓS o signIn
            ]);

            final result = notifier.state;
            expect(result, isA<AsyncData<UserAuth>>());
            expect(result.value, equals(testUser));

            verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
            verifyNever(mockGoogleAuthFacade.signInWithGoogle());
            verifyNoMoreInteractions(mockGoogleAuthFacade);
          },
        );
      });

      group('casos de erro', () {
        test(
          'signInWithGoogle lida com AuthException sem "null" na mensagem e emite AsyncError',
          () async {
            when(mockGoogleAuthFacade.getCurrentUser())
                .thenThrow(AuthException('Erro desconhecido'));

            final notifier =
                container.read(googleAuthNotifierProvider.notifier);

            final states = <AsyncValue<UserAuth>>[];

            final subscription = container.listen<AsyncValue<UserAuth>>(
              googleAuthNotifierProvider,
              (_, state) => states.add(state),
            );

            addTearDown(subscription.close);

            await notifier.signInWithGoogle();

            expect(states.length, 2);
            expect(states, [
              isA<AsyncLoading>(), // Estado DURANTE o signIn
              isA<AsyncError>(), // Estado APÓS o signIn
            ]);

            final error = (states[1] as AsyncError).error;
            expect(error, isA<AuthException>());
            expect((error as AuthException).message,
                contains('Erro inesperado: AuthException: Erro desconhecido'));

            verify(mockGoogleAuthFacade.getCurrentUser()).called(1);
            verifyNever(mockGoogleAuthFacade.signInWithGoogle());
          },
        );
      });
    });

    group('signOut', () {
      test('signOut calls signOut and invalidates state', () async {
        await container.read(googleAuthNotifierProvider.future);

        // Limpa histórico do mock para ignorar interações iniciais
        clearInteractions(mockGoogleAuthFacade);

        final notifier = container.read(googleAuthNotifierProvider.notifier);

        final states = <AsyncValue<UserAuth>>[];

        final subscription = container.listen<AsyncValue<UserAuth>>(
          googleAuthNotifierProvider,
          (_, state) => states.add(state),
        );

        addTearDown(subscription.close);

        await notifier.signOut();

        // Força o rebuild para disparar o build() e chamar getCurrentUser()
        await container.read(googleAuthNotifierProvider.future);

        // Assert - APENAS os estados do signOut
        expect(states.length, 2); // 2 estados: AsyncLoading e AsyncData
        expect(states, [
          isA<AsyncLoading>(),
          isA<AsyncData<UserAuth>>(),
        ]);

        verifyInOrder([
          mockGoogleAuthFacade.signOut(),
          mockGoogleAuthFacade.getCurrentUser(),
        ]);

        verifyNoMoreInteractions(mockGoogleAuthFacade);
      });
    });
  });
}
