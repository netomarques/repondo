import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/sign_up_with_email_use_case.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';

void main() {
  group('SignUpWithEmailUseCase', () {
    late SignUpWithEmailUseCase useCase;
    late MockEmailAuthRepository mockEmailAuthRepository;

    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const password = 'password';

    final expectedUser = UserAuthTestFactory.create();

    // Constante usada como retorno de sucesso
    final successWithUser = Success<UserAuth, AuthException>(expectedUser);

    setUp(() {
      mockEmailAuthRepository = MockEmailAuthRepository();
      useCase = SignUpWithEmailUseCase(mockEmailAuthRepository);

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<UserAuth, AuthException>>(successWithUser);
    });

    group('casos de sucesso', () {
      test(
          'deve chamar signUp com email e senha e retornar um Success<UserAuth, AuthException>',
          () async {
        // Arrange
        when(mockEmailAuthRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => successWithUser);

        // Act
        final result = await useCase.execute(email: email, password: password);

        // Assert
        expect(result, isA<Success<UserAuth, AuthException>>());

        final userAuth = result.data!;
        expect(userAuth.id, userId);
        expect(userAuth.email, email);
        expect(userAuth.name, userName);
        expect(userAuth.photoUrl, photoUrl);
        expect(userAuth.isAnonymous, isFalse);

        verify(mockEmailAuthRepository.signUpWithEmailAndPassword(
          email,
          password,
        )).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });

      group('casos de erro', () {
        test(
            'deve chamar signUp com email e senha e retornar um Failure<UserAuth, AuthException>',
            () async {
          final authFailureResult =
              Failure<UserAuth, AuthException>(AuthException('Error'));

          // Arrange
          when(mockEmailAuthRepository.signUpWithEmailAndPassword(any, any))
              .thenAnswer((_) async => authFailureResult);

          // Act
          final result =
              await useCase.execute(email: email, password: password);

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());
          verify(mockEmailAuthRepository.signUpWithEmailAndPassword(
            email,
            password,
          )).called(1);
          verifyNoMoreInteractions(mockEmailAuthRepository);
        });
      });
    });
  });
}
