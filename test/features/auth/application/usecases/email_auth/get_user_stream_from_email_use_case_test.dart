import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/get_user_stream_from_email_use_case.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  group('GetUserStreamFromEmailUseCase', () {
    late GetUserStreamFromEmailUseCase useCase;
    late MockEmailAuthRepository mockEmailAuthRepository;
    late StreamController<Result<UserAuth?, AuthException>> userController;

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
      useCase = GetUserStreamFromEmailUseCase(mockEmailAuthRepository);
      userController = StreamController<Result<UserAuth?, AuthException>>();

      // Fecha o StreamController após cada teste para evitar vazamentos
      addTearDown(userController.close);

      when(mockEmailAuthRepository.userStream)
          .thenAnswer((_) => userController.stream);
    });

    group('casos de sucesso', () {
      test('deve emitir Success com UserAuth', () async {
        // Arrange
        userController.add(successWithUser);

        // Act
        final result = await useCase.stream.first;

        // Assert
        expect(result, isA<Success<UserAuth?, AuthException>>());
        expect(result.data, isNotNull);

        final userAuth = result.data!;
        expect(userAuth.id, userId);
        expect(userAuth.email, email);
        expect(userAuth.name, userName);
        expect(userAuth.photoUrl, photoUrl);

        verify(mockEmailAuthRepository.userStream).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });
  });
}
