import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  group('EmailAuthFacade', () {
    late EmailAuthFacade emailAuthFacade;
    late MockSignInWithEmailAndPasswordUseCase
        mockSignInWithEmailAndPasswordUseCase;

    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const password = 'password';

    // Objeto UserAuth esperado em caso de sucesso
    final expectedUser = UserAuth(
      id: userId,
      email: email,
      name: userName,
      photoUrl: photoUrl,
    );

    // Resultado de sucesso que será retornado pelo mock
    final successUser = Success<UserAuth, AuthException>(expectedUser);

    setUp(() {
      // Inicializa mock e use case antes de cada teste
      mockSignInWithEmailAndPasswordUseCase =
          MockSignInWithEmailAndPasswordUseCase();

      // Cria uma instância da facade usando os mocks
      emailAuthFacade = EmailAuthFacade(
          signInWithEmailUseCase: mockSignInWithEmailAndPasswordUseCase);

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<UserAuth, AuthException>>(successUser);
    });

    group('casos de sucesso', () {
      test(
          'deve chamar execute() do SignInWithEmailAndPasswordUseCase e retornar Success<UserAuth, AuthException> quando signInWithEmail é chamado',
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
    });
    group('casos de erro', () {
      test(
          'deve chamar execute() do SignInWithEmailAndPasswordUseCase e retornar Failure<UserAuth, AuthException> quando signInWithEmail é chamado',
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
  });
}
