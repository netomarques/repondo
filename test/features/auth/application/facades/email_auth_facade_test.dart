import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../mocks/mocks.mocks.dart';
import '../../mocks/user_auth_test_factory.dart';

void main() {
  group('EmailAuthFacade', () {
    late EmailAuthFacade emailAuthFacade;
    late MockSignInWithEmailAndPasswordUseCase
        mockSignInWithEmailAndPasswordUseCase;
    late MockSignUpWithEmailUseCase mockSignUpWithEmailUseCase;
    late MockSignOutFromEmailAndPasswordUseCase mockSignOutFromEmailUseCase;
    late MockGetCurrentUserFromEmailUseCase mockGetCurrentUserFromEmailUseCase;
    late MockGetUserStreamFromEmailUseCase mockGetUserStreamFromEmailUseCase;

    const email = 'email@example.com';
    const password = 'password';

    // Objeto UserAuth esperado em caso de sucesso
    final expectedUser = UserAuthTestFactory.create();

    // Resultado de sucesso que será retornado pelo mock
    final successUser = Success<UserAuth, AuthException>(expectedUser);

    setUp(() {
      // Inicializa mock e use case antes de cada teste
      mockSignInWithEmailAndPasswordUseCase =
          MockSignInWithEmailAndPasswordUseCase();
      mockSignUpWithEmailUseCase = MockSignUpWithEmailUseCase();
      mockSignOutFromEmailUseCase = MockSignOutFromEmailAndPasswordUseCase();
      mockGetCurrentUserFromEmailUseCase = MockGetCurrentUserFromEmailUseCase();
      mockGetUserStreamFromEmailUseCase = MockGetUserStreamFromEmailUseCase();

      // Cria uma instância da facade usando os mocks
      emailAuthFacade = EmailAuthFacade(
        signInWithEmailUseCase: mockSignInWithEmailAndPasswordUseCase,
        signUpWithEmailUseCase: mockSignUpWithEmailUseCase,
        signOutFromEmaildUseCase: mockSignOutFromEmailUseCase,
        getCurrentUserFromEmailUseCase: mockGetCurrentUserFromEmailUseCase,
        getUserStreamFromEmailUseCase: mockGetUserStreamFromEmailUseCase,
      );

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<UserAuth, AuthException>>(successUser);
    });

    group('SignInWithEmailAndPasswordUseCase', () {
      test(
          'caso de sucesso - deve chamar execute() do SignInWithEmailAndPasswordUseCase e retornar Success<UserAuth, AuthException> quando signInWithEmail é chamado',
          () async {
        // Arrange
        when(mockSignInWithEmailAndPasswordUseCase.execute(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => successUser);

        // Act
        final result = await emailAuthFacade.signInWithEmail(email, password);

        // Assert
        expect(result, isA<Success<UserAuth, AuthException>>());
        verify(mockSignInWithEmailAndPasswordUseCase.execute(
          email: email,
          password: password,
        )).called(1);
        verifyNoMoreInteractions(mockSignInWithEmailAndPasswordUseCase);
      });

      test(
          'caso de erro - deve chamar execute() do SignInWithEmailAndPasswordUseCase e retornar Failure<UserAuth, AuthException> quando signInWithEmail é chamado',
          () async {
        final authFailureResult =
            Failure<UserAuth, AuthException>(AuthException('Error'));

        // Arrange
        when(mockSignInWithEmailAndPasswordUseCase.execute(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => authFailureResult);

        // Act
        final result = await emailAuthFacade.signInWithEmail(email, password);

        // Assert
        expect(result, isA<Failure<UserAuth, AuthException>>());
        verify(mockSignInWithEmailAndPasswordUseCase.execute(
          email: email,
          password: password,
        )).called(1);
        verifyNoMoreInteractions(mockSignInWithEmailAndPasswordUseCase);
      });
    });

    group('SignUpWithEmailUseCase', () {
      test(
          'caso de sucesso - deve chamar execute() do SignUpWithEmailUseCase e retornar Success<UserAuth, AuthException> quando signUpWithEmail é chamado',
          () async {
        // Arrange
        when(mockSignUpWithEmailUseCase.execute(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => successUser);

        // Act
        final result = await emailAuthFacade.signUpWithEmail(email, password);

        // Assert
        expect(result, isA<Success<UserAuth, AuthException>>());
        verify(mockSignUpWithEmailUseCase.execute(
          email: email,
          password: password,
        )).called(1);
        verifyNoMoreInteractions(mockSignUpWithEmailUseCase);
      });

      test(
          'caso de erro - deve chamar execute() do SignUpWithEmailUseCase e retornar Failure<UserAuth, AuthException> quando signUpWithEmail é chamado',
          () async {
        final authFailureResult =
            Failure<UserAuth, AuthException>(AuthException('Error'));

        // Arrange
        when(mockSignUpWithEmailUseCase.execute(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => authFailureResult);

        // Act
        final result = await emailAuthFacade.signUpWithEmail(email, password);

        // Assert
        expect(result, isA<Failure<UserAuth, AuthException>>());
        verify(mockSignUpWithEmailUseCase.execute(
          email: email,
          password: password,
        )).called(1);
        verifyNoMoreInteractions(mockSignUpWithEmailUseCase);
      });
    });

    group('SignOutFromEmailAndPasswordUseCase', () {
      final successVoid = Success<void, AuthException>(null);

      setUp(() {
        // Configuração do valor dummy para evitar MissingDummyValueError
        provideDummy<Result<void, AuthException>>(successVoid);
      });

      test(
          'caso de sucesso - deve chamar execute() do SignOutFromEmailAndPasswordUseCase e retornar Success<void, AuthException> quando signOut é chamado',
          () async {
        // Arrange
        when(mockSignOutFromEmailUseCase.execute())
            .thenAnswer((_) async => successVoid);

        // Act
        final result = await emailAuthFacade.signOut();

        // Assert
        expect(result, isA<Success<void, AuthException>>());
        verify(mockSignOutFromEmailUseCase.execute()).called(1);
        verifyNoMoreInteractions(mockSignOutFromEmailUseCase);
      });

      test(
          'caso de erro - deve chamar execute() do SignOutFromEmailAndPasswordUseCase e retornar Failure<void, AuthException> quando signOut é chamado',
          () async {
        final authFailureResult =
            Failure<UserAuth, AuthException>(AuthException('Error'));

        // Arrange
        when(mockSignOutFromEmailUseCase.execute())
            .thenAnswer((_) async => authFailureResult);

        // Act
        final result = await emailAuthFacade.signOut();

        // Assert
        expect(result, isA<Failure<void, AuthException>>());

        verify(mockSignOutFromEmailUseCase.execute()).called(1);
        verifyNoMoreInteractions(mockSignOutFromEmailUseCase);
      });
    });

    group('GetCurrentUserFromEmailUseCase', () {
      final successWithUser = Success<UserAuth?, AuthException>(expectedUser);

      setUp(() {
        // Configuração do valor dummy para evitar MissingDummyValueError
        provideDummy<Result<UserAuth?, AuthException>>(successWithUser);
      });

      test(
          'caso de sucesso - deve chamar fetch() do GetCurrentUserFromEmailUseCase e retornar Success<UserAuth?, AuthException> com UserAuth quando getCurrentUser é chamado',
          () async {
        // Arrange
        when(mockGetCurrentUserFromEmailUseCase.fetch())
            .thenAnswer((_) async => successWithUser);

        // Act
        final result = await emailAuthFacade.getCurrentUser();

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNotNull);

        verify(mockGetCurrentUserFromEmailUseCase.fetch()).called(1);
        verifyNoMoreInteractions(mockGetCurrentUserFromEmailUseCase);
      });

      test(
          'caso de sucesso - deve chamar fetch() do GetCurrentUserFromEmailUseCase e retornar Success<UserAuth?, AuthException> com null quando getCurrentUser é chamado',
          () async {
        final successWithNull = Success<UserAuth?, AuthException>(null);
        // Arrange
        when(mockGetCurrentUserFromEmailUseCase.fetch())
            .thenAnswer((_) async => successWithNull);

        // Act
        final result = await emailAuthFacade.getCurrentUser();

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNull);

        verify(mockGetCurrentUserFromEmailUseCase.fetch()).called(1);
        verifyNoMoreInteractions(mockGetCurrentUserFromEmailUseCase);
      });

      test(
          'caso de erro - deve chamar fetch() do GetCurrentUserFromEmailUseCase e retornar Failure<UserAuth?, AuthException> quando getCurrentUser é chamado',
          () async {
        final authFailureResult =
            Failure<UserAuth?, AuthException>(AuthException('Error'));

        // Arrange
        when(mockGetCurrentUserFromEmailUseCase.fetch())
            .thenAnswer((_) async => authFailureResult);

        // Act
        final result = await emailAuthFacade.getCurrentUser();

        // Assert
        expect(result, isA<Failure<UserAuth?, AuthException>>());

        verify(mockGetCurrentUserFromEmailUseCase.fetch()).called(1);
        verifyNoMoreInteractions(mockGetCurrentUserFromEmailUseCase);
      });
    });

    group('GetUserStreamFromEmailUseCase', () {
      late StreamController<Result<UserAuth?, AuthException>> userController;

      setUp(() {
        userController = StreamController<Result<UserAuth?, AuthException>>();

        // Fecha o StreamController após cada teste para evitar vazamentos
        addTearDown(userController.close);

        when(mockGetUserStreamFromEmailUseCase.stream)
            .thenAnswer((_) => userController.stream);

        // Configuração do valor dummy para evitar MissingDummyValueError
        provideDummy<Stream<Result<UserAuth?, AuthException>>>(
            userController.stream);
      });

      test(
          'caso de sucesso - deve chamar stream do GetUserStreamFromEmailUseCase e retornar Success<UserAuth?, AuthException> com UserAuth quando observeUserAuth é chamado',
          () async {
        // Arrange
        final successWithUser = Success<UserAuth?, AuthException>(expectedUser);
        userController.add(successWithUser);

        // Act
        final result = await emailAuthFacade.observeUserAuth.first;

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNotNull);

        verify(mockGetUserStreamFromEmailUseCase.stream).called(1);
        verifyNoMoreInteractions(mockGetUserStreamFromEmailUseCase);
      });

      test(
          'caso de sucesso - deve chamar stream do GetUserStreamFromEmailUseCase e retornar Success<UserAuth?, AuthException> com null quando observeUserAuth é chamado',
          () async {
        // Arrange
        final successWithNull = Success<UserAuth?, AuthException>(null);
        userController.add(successWithNull);

        // Act
        final result = await emailAuthFacade.observeUserAuth.first;

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNull);

        verify(mockGetUserStreamFromEmailUseCase.stream).called(1);
        verifyNoMoreInteractions(mockGetUserStreamFromEmailUseCase);
      });

      test(
          'caso de erro - deve chamar stream do GetUserStreamFromEmailUseCase e retornar Failure<UserAuth?, AuthException> quando observeUserAuth é chamado',
          () async {
        // Arrange
        final authFailureResult =
            Failure<UserAuth?, AuthException>(AuthException('Error'));
        userController.add(authFailureResult);

        // Act
        final result = await emailAuthFacade.observeUserAuth.first;

        // Assert
        expect(result, isA<Failure<UserAuth?, AuthException>>());

        verify(mockGetUserStreamFromEmailUseCase.stream).called(1);
        verifyNoMoreInteractions(mockGetUserStreamFromEmailUseCase);
      });
    });
  });
}
