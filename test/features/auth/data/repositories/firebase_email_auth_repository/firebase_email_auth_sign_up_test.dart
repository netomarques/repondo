import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/data/repositories/firebase_email_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

// Instâncias utilizadas em todos os testes
late FirebaseEmailAuthRepository firebaseEmailAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;
late MockUserCredential mockUserCredential;
late MockUser mockUser;

void _expectFailureAuthExceptionResult({
  required Result<UserAuth, AuthException> result,
  required String errorCode,
  required String message,
}) {
  expect(result, isA<Failure<UserAuth, AuthException>>());

  final failure = result.error!;
  expect(failure.message, contains(message));
  expect(failure.code, errorCode);

  verify(mockFirebaseAuth.createUserWithEmailAndPassword(
    email: anyNamed('email'),
    password: anyNamed('password'),
  )).called(1);
  verifyNoMoreInteractions(mockFirebaseAuth);
}

void main() {
  group('FirebaseEmailAuthRepository', () {
    // Dados simulados do usuário
    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const password = 'password';

    setUp(() {
      // Inicialização dos mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();

      // Instância do repositório com o mock injetado
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
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
    });

    group('signUpWithEmailAndPassword', () {
      group('casos de sucesso', () {
        test('deve retornar um UserAuth ao criar conta com sucesso', () async {
          // O cadastro é feito com email/senha, portanto:
          // - userCredential.user não será null
          // - user.email sempre estará presente
          // Não é necessário testar cenário com email null.

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          // Assert
          expect(result, isA<Success<UserAuth, AuthException>>(),
              reason:
                  'Esperado que o resultado seja um Success<UserAuth, AuthException>.');

          // Verifica os campos do UserAuth
          final userAuth = result.data!;
          expect(userAuth.id, userId);
          expect(userAuth.email, email);
          expect(userAuth.name, userName);
          expect(userAuth.photoUrl, photoUrl);

          verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
        test(
            'deve retornar UserAuth com name e photoUrl null ao criar conta com sucesso',
            () async {
          // O cadastro é feito com email/senha, portanto:
          // - userCredential.user não será null
          // - user.email sempre estará presente
          // Não é necessário testar cenário com email null.

          // Arrange
          when(mockUser.displayName).thenReturn(null);
          when(mockUser.photoURL).thenReturn(null);

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          // Assert
          expect(result, isA<Success<UserAuth, AuthException>>(),
              reason:
                  'Esperado que o resultado seja um Success<UserAuth, AuthException>.');

          // Verifica os campos do UserAuth
          final userAuth = result.data!;
          expect(userAuth.id, userId);
          expect(userAuth.email, email);
          expect(userAuth.name, null);
          expect(userAuth.photoUrl, null);

          verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });

      group('casos de erro', () {
        test(
            'Deve retornar Failure<AuthException> quando UserCrendencial.user for null',
            () async {
          // Arrange
          when(mockUserCredential.user).thenReturn(null);

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());

          final failure = result.error!;
          expect(failure.message, contains('Usuário é null após a criação'));

          verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).called(1);
          verify(mockUserCredential.user).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test(
            'Deve retornar Failure<AuthException> quando email já foi cadastrado',
            () async {
          const errorCode = 'email-already-in-use';
          const message = 'E-mail já está em uso';

          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          _expectFailureAuthExceptionResult(
              result: result, errorCode: errorCode, message: message);
        });
        test('Deve retornar Failure<AuthException> quando a senha for fraca',
            () async {
          const errorCode = 'weak-password';
          const message =
              'A senha é muito fraca. Escolha uma senha com pelo menos 6 caracteres';

          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          _expectFailureAuthExceptionResult(
              result: result, errorCode: errorCode, message: message);
        });
        test('Deve retornar Failure<AuthException> quando o email é inválido',
            () async {
          const errorCode = 'invalid-email';
          const message = 'Credenciais inválidas';

          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: errorCode));

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          _expectFailureAuthExceptionResult(
              result: result, errorCode: errorCode, message: message);
        });

        test(
            'Deve retornar Failure<AuthException> quando o erro foi desconhecido',
            () async {
          const errorCode = 'unknown-error';
          const message = 'Erro desconhecido';

          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(
              FirebaseAuthException(code: errorCode, message: message));

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          _expectFailureAuthExceptionResult(
              result: result, errorCode: errorCode, message: message);
        });

        test(
            'Deve retornar Failure<AuthException> genérica para erros desconhecidos',
            () async {
          const message = 'Erro ao criar conta: ';

          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(Exception('Erro genérico'));

          // Act
          final result = await firebaseEmailAuthRepository
              .signUpWithEmailAndPassword(email, password);

          expect(result, isA<Failure<UserAuth, AuthException>>());

          final failure = result.error!;
          expect(failure.message, contains(message));

          verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
