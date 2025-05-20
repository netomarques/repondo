import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/get_current_user_from_email_use_case.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  group('GetCurrentUserFromEmailUseCase', () {
    late GetCurrentUserFromEmailUseCase useCase;
    late MockEmailAuthRepository mockEmailAuthRepository;

    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';

    final expectedUser = UserAuth(
      id: userId,
      email: email,
      name: userName,
      photoUrl: photoUrl,
    );

    // Constante usada como retorno de sucesso
    final successWithUser = Success<UserAuth?, AuthException>(expectedUser);

    setUp(() {
      mockEmailAuthRepository = MockEmailAuthRepository();
      useCase = GetCurrentUserFromEmailUseCase(mockEmailAuthRepository);

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<UserAuth?, AuthException>>(successWithUser);
    });

    group('casos de sucesso', () {
      test(
          'deve chamar getCurrentUser e retornar um Success<UserAuth?, AuthException> com o usuário autenticado quando não for null',
          () async {
        // Arrange
        when(mockEmailAuthRepository.getCurrentUser())
            .thenAnswer((_) async => successWithUser);

        // Act
        final result = await useCase.fetch();

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNotNull);

        final userAuth = result.data!;
        expect(userAuth.id, userId);
        expect(userAuth.email, email);
        expect(userAuth.name, userName);
        expect(userAuth.photoUrl, photoUrl);
        expect(userAuth.isAnonymous, isFalse);

        verify(mockEmailAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });

      test(
          'deve chamar getCurrentUser e retornar um Success<UserAuth?, AuthException> com null',
          () async {
        final successWithNull = Success<UserAuth?, AuthException>(null);

        // Arrange
        when(mockEmailAuthRepository.getCurrentUser())
            .thenAnswer((_) async => successWithNull);

        // Act
        final result = await useCase.fetch();

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNull);

        verify(mockEmailAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });

    group('casos de erro', () {
      test(
          'deve chamar getCurrentUser e retornar um Failure<UserAuth?, AuthException>',
          () async {
        // Cria um Failure para simular erro no getCurrentUser
        final failureUserAuth =
            Failure<UserAuth?, AuthException>(AuthException('Error'));

        // Arrange
        when(mockEmailAuthRepository.getCurrentUser())
            .thenAnswer((_) async => failureUserAuth);

        // Act
        final result = await useCase.fetch();

        // Assert
        expect(result, isA<Failure<UserAuth?, AuthException>>());

        final failure = result.error!;
        expect(failure.message, contains('Error'));

        verify(mockEmailAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });
  });
}
