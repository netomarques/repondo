import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/sign_in_with_email_and_password_use_case.dart';
import 'package:repondo/features/auth/domain/exports.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  group('SignInWithEmailAndPasswordUseCase', () {
    late SignInWithEmailAndPasswordUseCase useCase;
    late MockEmailAuthRepository mockEmailAuthRepository;

    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const password = 'password';
    // const isAnonymous = false;

    final expectedUser = UserAuth(
      id: userId,
      email: email,
      name: userName,
      photoUrl: photoUrl,
    );

    setUp(() {
      mockEmailAuthRepository = MockEmailAuthRepository();
      useCase = SignInWithEmailAndPasswordUseCase(mockEmailAuthRepository);

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<UserAuth, AuthException>>(Success(expectedUser));
    });

    group('casos de sucesso', () {
      test(
          'deve chamar signIn com email e senha e retornar um Success<UserAuth, AuthException>',
          () async {
        // Arrange
        when(mockEmailAuthRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Success(expectedUser));

        // Act
        final result = await useCase.execute(email: email, password: password);
        expect(result, isA<Success<UserAuth, AuthException>>());

        final userAuth = result.data!;

        expect(userAuth.id, userId);
        expect(userAuth.email, email);
        expect(userAuth.name, userName);
        expect(userAuth.photoUrl, photoUrl);
        expect(userAuth.isAnonymous, isFalse);

        verify(mockEmailAuthRepository.signInWithEmailAndPassword(
          email,
          password,
        )).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });

    group('casos de erro', () {
      test(
          'deve chamar signIn com email e senha e retornar um Failure<UserAuth, AuthException>',
          () async {
        // Arrange
        when(mockEmailAuthRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Failure(AuthException('Error')));

        // Act
        final result = await useCase.execute(email: email, password: password);

        // Assert
        expect(result, isA<Failure<UserAuth, AuthException>>());

        final failure = result.error!;
        expect(failure.message, contains('Error'));

        verify(mockEmailAuthRepository.signInWithEmailAndPassword(
          email,
          password,
        )).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });
  });
}
