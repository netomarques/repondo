import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/data/repositories/firebase_google_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../mocks/mocks.mocks.dart';

// Instanciando mocks de classes necessárias para os testes
late MockGoogleSignIn mockGoogleSignIn;
late MockFirebaseAuth mockFirebaseAuth;
late MockGoogleSignInAccount mockGoogleSignInAccount;
late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
late MockUserCredential mockFirebaseAuthUserCredential;
late MockUser mockFirebaseAuthUser;
late FirebaseGoogleAuthRepository firebaseGoogleAuthRepository;
late AuthCredential capturedCredential;

void main() {
  // Inicialização dos mocks
  mockGoogleSignIn = MockGoogleSignIn();
  mockFirebaseAuth = MockFirebaseAuth();
  mockGoogleSignInAccount = MockGoogleSignInAccount();
  mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
  mockFirebaseAuthUserCredential = MockUserCredential();
  mockFirebaseAuthUser = MockUser();

  // Inicialização do repositório que será testado
  firebaseGoogleAuthRepository = FirebaseGoogleAuthRepository(
    googleSignIn: mockGoogleSignIn,
    firebaseAuth: mockFirebaseAuth,
  );

  group('FirebaseGoogleAuthReposity', () {
    setUp(() {
      // Resetando mocks antes de cada teste para garantir que nenhum estado anterior interfira
      reset(mockGoogleSignIn);
      reset(mockFirebaseAuth);
      reset(mockGoogleSignInAccount);
      reset(mockGoogleSignInAuthentication);
      reset(mockFirebaseAuthUserCredential);
      reset(mockFirebaseAuthUser);

      // Simulando o fluxo de login do Google
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);

      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      // Simulando tokens de autenticação válidos do Google
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('access-token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id-token');

      // Simulando a resposta da autenticação no Firebase com as credenciais do Google
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((invocation) async {
        capturedCredential =
            invocation.positionalArguments.first as AuthCredential;
        return mockFirebaseAuthUserCredential;
      });

      // Simulando o usuário do Firebase
      when(mockFirebaseAuthUserCredential.user)
          .thenReturn(mockFirebaseAuthUser);

      when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseAuthUser);

      // Simulando o logout do Google e Firebase
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Atribuindo valores simulados ao usuário
      when(mockFirebaseAuthUser.uid).thenReturn('uid-123');
      when(mockFirebaseAuthUser.displayName).thenReturn('Zé Dev');
      when(mockFirebaseAuthUser.email).thenReturn('ze@dev.com');
      when(mockFirebaseAuthUser.photoURL)
          .thenReturn('https://example.com/photo.jpg');
      when(mockFirebaseAuthUser.isAnonymous).thenReturn(false);
    });

    group('signIn', () {
      group('casos de sucesso', () {
        test('Deve usar o GoogleAuthProvider (google.com) no signIn', () async {
          await firebaseGoogleAuthRepository.signIn();

          // Verificando se o GoogleAuthProvider foi utilizado no login
          expect(capturedCredential.providerId, equals('google.com'));
        });

        test('signIn deve retornar um domínio UserAuth', () async {
          final result = await firebaseGoogleAuthRepository.signIn();
          // Verificando se o retorno é um objeto UserAuth
          expect(result, isA<UserAuth>());
        });

        test('Deve autenticar com Google e retornar um UserAuth corretamente',
            () async {
          final result = await firebaseGoogleAuthRepository.signIn();

          // Verificando se as informações do usuário estão corretas após o login
          expect(result.id, 'uid-123');
          expect(result.name, 'Zé Dev');
          expect(result.email, 'ze@dev.com');
          expect(result.photoUrl, 'https://example.com/photo.jpg');

          // Verificando as chamadas feitas para o login
          verify(mockGoogleSignIn.signIn()).called(1);
          verify(mockGoogleSignInAccount.authentication).called(1);
          verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
        });

        test(
            'Deve retornar UserAuth com name, email e photo null se forem null',
            () async {
          // Simulando que o Firebase retornou valores nulos para o nome, email e foto
          when(mockFirebaseAuthUser.displayName).thenReturn(null);
          when(mockFirebaseAuthUser.email).thenReturn(null);
          when(mockFirebaseAuthUser.photoURL).thenReturn(null);

          final result = await firebaseGoogleAuthRepository.signIn();

          // Verificando se o retorno tem os campos nulos
          expect(result.id, 'uid-123');
          expect(result.name, null);
          expect(result.email, null);
          expect(result.photoUrl, null);
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException se o login for cancelado pelo usuário',
            () async {
          // Simulando o cancelamento do login pelo usuário
          when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

          // Verificando se a exceção é lançada corretamente
          expect(
            () async => await firebaseGoogleAuthRepository.signIn(),
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('cancelado'))),
          );
        });

        test('Deve lançar AuthException se signInWithCredential falhar',
            () async {
          // Simulando um erro durante o login
          when(mockFirebaseAuth.signInWithCredential(any))
              .thenThrow(FirebaseAuthException(code: 'unknown'));

          expect(
            () async => await firebaseGoogleAuthRepository.signIn(),
            throwsA(isA<AuthException>()),
          );
        });

        test(
            'Deve lançar AuthException se user do firebase for null após autenticação',
            () async {
          // Simulando que o usuário retornado é nulo
          when(mockFirebaseAuthUserCredential.user).thenReturn(null);

          expect(
            () async => await firebaseGoogleAuthRepository.signIn(),
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('null'))),
          );
        });
      });
    });

    group('getCurrentUser', () {
      group('casos de sucesso', () {
        test('getCurrentUser deve retornar um domínio UserAuth', () async {
          final result = await firebaseGoogleAuthRepository.getCurrentUser();
          // Verificando se o retorno é um objeto UserAuth
          expect(result, isA<UserAuth>());
        });

        test('Deve retornar um UserAuth válido', () async {
          final result = await firebaseGoogleAuthRepository.getCurrentUser();

          // Verificando se as informações do usuário estão corretas
          expect(result!.id, 'uid-123');
          expect(result.name, 'Zé Dev');
          expect(result.email, 'ze@dev.com');
          expect(result.photoUrl, 'https://example.com/photo.jpg');
          verify(mockFirebaseAuth.currentUser).called(1);
        });

        test(
            'Deve retornar name, email e photoUrl null se forem null no Firebase',
            () async {
          when(mockFirebaseAuthUser.displayName).thenReturn(null);
          when(mockFirebaseAuthUser.email).thenReturn(null);
          when(mockFirebaseAuthUser.photoURL).thenReturn(null);

          final result = await firebaseGoogleAuthRepository.getCurrentUser();

          // Verificando se o retorno tem os campos nulos
          expect(result!.id, 'uid-123');
          expect(result.name, null);
          expect(result.email, null);
          expect(result.photoUrl, null);
          verify(mockFirebaseAuth.currentUser).called(1);
        });

        test('deve retornar UserAuth null caso user do firebase seja null ',
            () async {
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          final result = await firebaseGoogleAuthRepository.getCurrentUser();

          // Verificando se o retorno é nulo
          expect(result, null);
          verify(mockFirebaseAuth.currentUser).called(1);
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException caso ocorra Excpetion genérico',
            () async {
          // Simulando que erro genérico foi lançado
          when(mockFirebaseAuth.currentUser).thenThrow(Exception('Erro'));

          expect(
            () => firebaseGoogleAuthRepository.getCurrentUser(),
            throwsA(isA<AuthException>()),
          );
        });

        test('Deve lançar AuthException caso o Firebase lance erro inesperado',
            () async {
          when(mockFirebaseAuth.currentUser).thenThrow(FirebaseAuthException(
            code: 'internal-error',
            message: 'Erro interno',
          ));

          expect(
            () => firebaseGoogleAuthRepository.getCurrentUser(),
            throwsA(isA<AuthException>()),
          );
        });
      });
    });

    group('signOut', () {
      group('casos de sucesso', () {
        test('Deve chamar signOut do Google e do Firebase corretamente',
            () async {
          await firebaseGoogleAuthRepository.signOut();

          // Verificando se as funções de signOut foram chamadas corretamente
          verify(mockGoogleSignIn.signOut());
          verify(mockFirebaseAuth.signOut());
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException se ocorrer um erro no signOut',
            () async {
          // Simulando um erro no Google signOut
          when(mockGoogleSignIn.signOut())
              .thenThrow(Exception('Erro no Google'));

          expect(
            () async => await firebaseGoogleAuthRepository.signOut(),
            throwsA(isA<AuthException>().having((e) => e.message, 'mensagem',
                contains('Erro ao fazer logout'))),
          );
        });

        test(
            'deve lançar AuthException se firebaseAuth.signOut falhar após googleSignIn.signOut',
            () async {
          // Simulando um erro no Firebase signOut
          when(mockFirebaseAuth.signOut())
              .thenThrow(Exception('Erro Firebase'));

          expect(
            () async => await firebaseGoogleAuthRepository.signOut(),
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('logout'))),
          );

          verify(mockGoogleSignIn.signOut()).called(1);
          verifyNever(mockFirebaseAuth.signOut());
        });

        test(
            'Deve lançar AuthException e não deve chamar firebaseAuth.signOut se falhar googleSignIn.signOut',
            () async {
          when(mockGoogleSignIn.signOut())
              .thenThrow(Exception('Erro no logout do google'));

          expect(
            () async => await firebaseGoogleAuthRepository.signOut(),
            throwsA(isA<AuthException>().having((e) => e.message, 'mensagem',
                contains('Erro ao fazer logout'))),
          );

          verify(mockGoogleSignIn.signOut());
          verifyNever(mockFirebaseAuth.signOut());
        });
      });
    });

    group('userStream', () {
      group('casos de sucesso', () {
        test('deve emitir um UserAuth quando o Firebase emitir um User', () {
          when(mockFirebaseAuth.authStateChanges())
              .thenAnswer((_) => Stream.value(mockFirebaseAuthUser));

          expectLater(
            firebaseGoogleAuthRepository.userStream,
            emits(isA<UserAuth>()),
          );
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException se Firebase emitir null', () async {
          when(mockFirebaseAuth.authStateChanges())
              .thenAnswer((_) => Stream.value(null));

          expect(
            firebaseGoogleAuthRepository.userStream.first,
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('null'))),
          );
        });
      });
    });
  });
}
