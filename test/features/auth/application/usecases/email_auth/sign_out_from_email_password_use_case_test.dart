import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/sign_out_from_email_and_password_use_case.dart';
import 'package:repondo/features/auth/domain/exports.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  group('SignOutFromEmailAndPasswordUseCase', () {
    late SignOutFromEmailAndPasswordUseCase useCase;
    late MockEmailAuthRepository mockEmailAuthRepository;

    // Constante usada como retorno de sucesso
    const successVoid = Success<void, AuthException>(null);

    setUp(() {
      // Inicializa mock e use case antes de cada teste
      mockEmailAuthRepository = MockEmailAuthRepository();
      useCase = SignOutFromEmailAndPasswordUseCase(mockEmailAuthRepository);

      // Configuração do valor dummy para evitar MissingDummyValueError
      provideDummy<Result<void, AuthException>>(successVoid);
    });

    group('casos de sucesso', () {
      test('deve chamar signOut e retornar um Success<void, AuthException>',
          () async {
        // Arrange
        when(mockEmailAuthRepository.signOut())
            .thenAnswer((_) async => successVoid);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, isA<Success<void, AuthException>>());
        verify(mockEmailAuthRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });

    group('casos de erro', () {
      test('deve chamar signOut e retornar um Failure<void, AuthException>',
          () async {
        // Cria um Failure para simular erro no logout
        final failureVoid =
            Failure<void, AuthException>(AuthException('Error'));

        // Arrange
        when(mockEmailAuthRepository.signOut())
            .thenAnswer((_) async => failureVoid);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, isA<Failure<void, AuthException>>());
        verify(mockEmailAuthRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockEmailAuthRepository);
      });
    });
  });
}
