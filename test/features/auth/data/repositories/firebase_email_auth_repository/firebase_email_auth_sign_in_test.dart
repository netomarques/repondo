import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/exports.dart';
import 'package:repondo/features/auth/data/repositories/firebase_email_auth_repository.dart';
import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

late FirebaseEmailAuthRepository firebaseEmailAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;
late MockUserCredential mockUserCredential;
late MockUser mockUser;

void _expectSuccessUserAuthResult({
  required Result<UserAuth, AuthException> result,
  required String expectedId,
  required String? expectedEmail,
  required String? expectedName,
  required String? expectedPhotoUrl,
}) {
  // Verifica se o resultado foi um sucesso contendo um UserAuth
  expect(result, isA<Success<UserAuth, AuthException>>(),
      reason:
          'Esperado que o resultado seja um Success<UserAuth, AuthException>.');

  final userAuth = result.data!;
  // Verifica os campos do UserAuth
  expect(userAuth.id, expectedId);
  expect(userAuth.email, expectedEmail);
  expect(userAuth.name, expectedName);
  expect(userAuth.photoUrl, expectedPhotoUrl);

  // Verifica se o método correto foi chamado no FirebaseAuth
  verify(mockFirebaseAuth.signInWithEmailAndPassword(
    email: anyNamed('email'),
    password: anyNamed('password'),
  )).called(1);
  verifyNoMoreInteractions(mockFirebaseAuth);
}

void _expectFailureAuthExceptionResult({
  required Result<UserAuth, AuthException> result,
  required String errorCode,
  required String message,
}) {
  expect(result, isA<Failure<UserAuth, AuthException>>());

  final failure = result.error!;
  expect(failure.message, contains(message));
  expect(failure.code, errorCode);

  verify(mockFirebaseAuth.signInWithEmailAndPassword(
    email: anyNamed('email'),
    password: anyNamed('password'),
  )).called(1);

  verifyNoMoreInteractions(mockFirebaseAuth);
}

void main() {
  group('FirebaseEmailAuthRepository', () {
    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const password = 'password';
    const isAnonymous = false;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();

      firebaseEmailAuthRepository =
          FirebaseEmailAuthRepository(firebaseAuth: mockFirebaseAuth);

      // Configurando o mockUser para retornar um email válido
      // e um ID de usuário válido
      // e um email de usuário válido
      // e um nome de usuário válido
      // e uma URL de foto válida
      when(mockUser.uid).thenReturn(userId);
      when(mockUser.email).thenReturn(email);
      when(mockUser.displayName).thenReturn(userName);
      when(mockUser.photoURL).thenReturn(photoUrl);
      when(mockUser.isAnonymous).thenReturn(isAnonymous);
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
    });

    group('signInWithEmailAndPassword', () {
      group('casos de sucesso', () {
        test(
            'deve retornar UserAuth válido ao fazer login com email e senha válidos',
            () async {
          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: email,
            expectedName: userName,
            expectedPhotoUrl: photoUrl,
          );
        });

        test('Deve retornar UserAuth válido com campos nulos', () async {
          // Arrange simula campos nulos vindos do FirebaseUser
          when(mockUser.email).thenReturn(null);
          when(mockUser.displayName).thenReturn(null);
          when(mockUser.photoURL).thenReturn(null);

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: null,
            expectedName: null,
            expectedPhotoUrl: null,
          );
        });

        test('Deve retornar UserAuth válido com email nulo', () async {
          // Arrange: simula o retorno do FirebaseUser com email nulo
          when(mockUser.email).thenReturn(null);

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: null,
            expectedName: userName,
            expectedPhotoUrl: photoUrl,
          );
        });

        test('Deve retornar UserAuth válido com name nulo', () async {
          // Arrange: simula o retorno do FirebaseUser com name nulo
          when(mockUser.displayName).thenReturn(null);

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: email,
            expectedName: null,
            expectedPhotoUrl: photoUrl,
          );
        });

        test('Deve retornar UserAuth válido com photoUrl nulo', () async {
          // Arrange: simula o retorno do FirebaseUser com photoURL nulo
          when(mockUser.photoURL).thenReturn(null);

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: email,
            expectedName: userName,
            expectedPhotoUrl: null,
          );
        });
      });

      group('casos de erro', () {
        test(
          'deve retornar Failure<AuthException> quando userCredential.user for null',
          () async {
            // Arrange
            when(mockUserCredential.user).thenReturn(null);

            // Act
            final result = await firebaseEmailAuthRepository
                .signInWithEmailAndPassword(email, password);

            // Assert
            expect(result, isA<Failure<UserAuth, AuthException>>());

            final failure = result.error!;
            expect(failure.message,
                contains('Usuário retornado é null após autenticação'));

            verify(mockFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'),
              password: anyNamed('password'),
            )).called(1);

            verify(mockUserCredential.user).called(1);
            verifyNoMoreInteractions(mockFirebaseAuth);
          },
        );

        test(
            'Deve lançar Failure<AuthException> quando credenciais forem inválidas',
            () async {
          // Constants
          const wrongPassword = 'wrong-password';
          const errorCode = 'wrong-password';

          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: wrongPassword,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, wrongPassword);

          // Assert
          _expectFailureAuthExceptionResult(
            result: result,
            errorCode: errorCode,
            message: 'Credenciais inválidas',
          );
        });

        test('Deve lançar Failure<AuthException> quando o email for inválido',
            () async {
          const wrongEmail = 'invalid-email';
          const errorCode = 'invalid-email';

          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: wrongEmail,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(wrongEmail, password);

          // Assert
          _expectFailureAuthExceptionResult(
            result: result,
            errorCode: errorCode,
            message: 'Credenciais inválidas',
          );
        });

        test('Deve lançar Failure<AuthException> quando o usuário não existir',
            () async {
          const errorCode = 'user-not-found';

          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectFailureAuthExceptionResult(
            result: result,
            errorCode: errorCode,
            message: 'Usuário não existe',
          );
        });

        test('Deve lançar Failure<AuthException> quando conta for desativada',
            () async {
          const errorCode = 'user-disabled';

          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          _expectFailureAuthExceptionResult(
            result: result,
            errorCode: errorCode,
            message: 'Conta desativada',
          );
        });

        test(
            'Deve lançar Failure<AuthException> quando for um erro de FirebaseAuthException não rastreado',
            () async {
          const errorCode = 'erro-nao-identificado';

          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());

          final failure = result as Failure<UserAuth, AuthException>;
          expect(failure.error.message,
              contains(AuthErrorMessages.authUnknownError));
          expect(failure.error.code, isNotNull);

          verify(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).called(1);

          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test(
            'Deve lançar Failure<AuthException> genérica para erros desconhecidos',
            () async {
          // Arrange
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(Exception('Erro desconhecido'));

          // Act
          final result = await firebaseEmailAuthRepository
              .signInWithEmailAndPassword(email, password);

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());

          final failure = result as Failure<UserAuth, AuthException>;
          expect(failure.error.message, contains('Erro de autenticação'));

          verify(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).called(1);

          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
