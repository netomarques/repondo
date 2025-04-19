import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/data/repositories/firebase_google_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/user.dart' as authDomain;
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import 'firebase_google_auth_repository_test.mocks.dart';

@GenerateMocks([
  fbAuth.FirebaseAuth,
  fbAuth.UserCredential,
  fbAuth.User,
  fbAuth.UserInfo,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication
])
late MockGoogleSignIn mockGoogleSignIn;
late MockFirebaseAuth mockFirebaseAuth;
late MockGoogleSignInAccount mockGoogleSignInAccount;
late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
late MockUserCredential mockFirebaseAuthUserCredential;
late MockUser mockFirebaseAuthUser;
late FirebaseGoogleAuthRepository firebaseGoogleAuthRepository;
late fbAuth.AuthCredential capturedCredential;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockGoogleSignIn = MockGoogleSignIn();
  mockFirebaseAuth = MockFirebaseAuth();
  mockGoogleSignInAccount = MockGoogleSignInAccount();
  mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
  mockFirebaseAuthUserCredential = MockUserCredential();
  mockFirebaseAuthUser = MockUser();
  firebaseGoogleAuthRepository = FirebaseGoogleAuthRepository(
    googleSignIn: mockGoogleSignIn,
    firebaseAuth: mockFirebaseAuth,
  );

  group('FirebaseGoogleAuthReposity', () {
    setUp(() {
      reset(mockGoogleSignIn);
      reset(mockFirebaseAuth);
      reset(mockGoogleSignInAccount);
      reset(mockGoogleSignInAuthentication);
      reset(mockFirebaseAuthUserCredential);
      reset(mockFirebaseAuthUser);

      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);

      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('access-token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id-token');

      // when(mockFirebaseAuth.signInWithCredential(any))
      //     .thenAnswer((_) async => mockFirebaseAuthUserCredential);

      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((invocation) async {
        capturedCredential =
            invocation.positionalArguments.first as fbAuth.AuthCredential;
        return mockFirebaseAuthUserCredential;
      });

      when(mockFirebaseAuthUserCredential.user)
          .thenReturn(mockFirebaseAuthUser);

      when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseAuthUser);

      when(mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      when(mockFirebaseAuthUser.uid).thenReturn('uid-123');
      when(mockFirebaseAuthUser.displayName).thenReturn('Zé Dev');
      when(mockFirebaseAuthUser.email).thenReturn('ze@dev.com');
    });

    group('signIn', () {
      group('casos de sucesso', () {
        test('Deve usar o GoogleAuthProvider (google.com) no signIn', () async {
          await firebaseGoogleAuthRepository.signIn();

          expect(capturedCredential.providerId, equals('google.com'));
        });

        test('signIn deve retornar um domínio User', () async {
          final result = await firebaseGoogleAuthRepository.signIn();
          expect(result, isA<authDomain.User>());
        });

        test('Deve autenticar com Google e retornar um User corretamente',
            () async {
          final result = await firebaseGoogleAuthRepository.signIn();

          expect(result.id, 'uid-123');
          expect(result.name, 'Zé Dev');
          expect(result.email, 'ze@dev.com');

          verify(mockGoogleSignIn.signIn()).called(1);
          verify(mockGoogleSignInAccount.authentication).called(1);
          verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
        });

        test(
            'Deve retornar User com name e email vazios se displayName e email forem null',
            () async {
          when(mockFirebaseAuthUser.displayName).thenReturn(null);
          when(mockFirebaseAuthUser.email).thenReturn(null);

          final result = await firebaseGoogleAuthRepository.signIn();

          expect(result.id, 'uid-123');
          expect(result.name, '');
          expect(result.email, '');
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException se o login for cancelado pelo usuário',
            () async {
          when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

          expect(
            () async => await firebaseGoogleAuthRepository.signIn(),
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('cancelado'))),
          );
        });

        test('Deve lançar AuthException se signInWithCredential falhar',
            () async {
          when(mockFirebaseAuth.signInWithCredential(any))
              .thenThrow(fbAuth.FirebaseAuthException(code: 'unknown'));

          expect(
            () async => await firebaseGoogleAuthRepository.signIn(),
            throwsA(isA<AuthException>()),
          );
        });

        test(
            'Deve lançar AuthException se user do firebase for nulo após autenticação',
            () async {
          when(mockFirebaseAuthUserCredential.user).thenReturn(null);

          expect(
            () async => await firebaseGoogleAuthRepository.signIn(),
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('nulo'))),
          );
        });
      });
    });

    group('getCurrentUser', () {
      group('casos de sucesso', () {
        test('getCurrentUser deve retornar um domínio User', () async {
          final result = await firebaseGoogleAuthRepository.getCurrentUser();
          expect(result, isA<authDomain.User>());
        });

        test('Deve retornar um User válido', () async {
          final result = await firebaseGoogleAuthRepository.getCurrentUser();

          expect(result.id, 'uid-123');
          expect(result.name, 'Zé Dev');
          expect(result.email, 'ze@dev.com');
          verify(mockFirebaseAuth.currentUser).called(1);
        });
      });

      group('casos de erro', () {
        test('Deve retornar name e email vazios se forem nulos no Firebase',
            () async {
          when(mockFirebaseAuthUser.displayName).thenReturn(null);
          when(mockFirebaseAuthUser.email).thenReturn(null);

          final result = await firebaseGoogleAuthRepository.getCurrentUser();

          expect(result.id, 'uid-123');
          expect(result.name, '');
          expect(result.email, '');
          verify(mockFirebaseAuth.currentUser).called(1);
        });

        test('Deve lançar AuthException se currentUser for nulo', () async {
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          expect(
            () => firebaseGoogleAuthRepository.getCurrentUser(),
            throwsA(isA<AuthException>()
                .having((e) => e.message, 'mensagem', contains('nulo'))),
          );
        });
      });
    });

    group('signOut', () {
      group('casos de sucesso', () {
        test('Deve chamar signOut do Google e do Firebase corretamente',
            () async {
          await firebaseGoogleAuthRepository.signOut();

          verify(mockGoogleSignIn.signOut());
          verify(mockFirebaseAuth.signOut());
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException se ocorrer um erro no signOut',
            () async {
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
        test(
            'deve emitir um authDomain.User quando o Firebase emitir um fbAuth.User',
            () {
          when(mockFirebaseAuth.authStateChanges())
              .thenAnswer((_) => Stream.value(mockFirebaseAuthUser));

          expectLater(
            firebaseGoogleAuthRepository.userStream,
            emits(isA<authDomain.User>()),
          );
        });

        test('deve emitir múltiplos authDomain.User corretamente', () async {
          final mockFirebaseAuthUser2 = MockUser();
          when(mockFirebaseAuthUser2.uid).thenReturn('uid-456');
          when(mockFirebaseAuthUser2.displayName).thenReturn('José Dev');
          when(mockFirebaseAuthUser2.email).thenReturn('José@dev.com');

          when(mockFirebaseAuth.authStateChanges())
              .thenAnswer((_) => Stream.fromIterable([
                    mockFirebaseAuthUser,
                    mockFirebaseAuthUser2,
                  ]));

          expectLater(
            firebaseGoogleAuthRepository.userStream,
            emitsInOrder([
              isA<authDomain.User>(),
              isA<authDomain.User>(),
            ]),
          );
        });
      });

      group('casos de erro', () {
        test('Deve lançar AuthException se Firebase emitir null', () async {
          when(mockFirebaseAuth.authStateChanges())
              .thenAnswer((_) => Stream.value(null));

          expect(
            firebaseGoogleAuthRepository.userStream.first,
            throwsA(isA<AuthException>().having((e) => e.message, 'mensagem',
                contains('User do Firebase é nulo'))),
          );
        });
      });
    });
  });
}
