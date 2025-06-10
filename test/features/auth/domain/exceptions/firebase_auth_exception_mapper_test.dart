import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/features/auth/domain/exports.dart';

/// Função helper para verificar se um [FirebaseAuthException]
/// é corretamente convertido para um [AuthException] esperado.
///
/// Reduz duplicação nos testes e melhora legibilidade.
void _expectFirebaseAuthExceptionMapping({
  required Type exceptionType,
  required String errorCode,
  required String expectedMessage,
}) {
  // Arrange: cria uma exceção do Firebase com o código fornecido.
  final error = FirebaseAuthException(code: errorCode);

  // Act: realiza o mapeamento com a função testada.
  final result = fromFirebaseAuthExceptionMapper(error);

  // Assert: verifica se o mapeamento retornou corretamente o tipo da exceção.
  expect(result.runtimeType, exceptionType,
      reason: 'Deveria retornar uma exceção do tipo "$exceptionType"');
  expect(result.message, expectedMessage,
      reason: 'Mensagem deveria ser "$expectedMessage"');
  expect(result.code, errorCode, reason: 'Código deveria ser "$errorCode"');
}

void main() {
  group('fromFirebaseAuthExceptionMapper', () {
    // Testa o código 'wrong-password'
    test(
        'deve retornar AuthException com mensagem de credenciais inválidas quando code for wrong-password',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: InvalidCredentialsException,
        errorCode: FirebaseAuthErrorCodes.wrongPassword,
        expectedMessage: AuthErrorMessages.invalidCredentials,
      );
    });

    // Testa o código 'invalid-email'
    test(
        'deve retornar AuthException com mensagem de credenciais inválidas quando code for invalid-email',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: InvalidCredentialsException,
        errorCode: FirebaseAuthErrorCodes.invalidEmail,
        expectedMessage: AuthErrorMessages.invalidCredentials,
      );
    });

    // Testa o código 'invalid-credential'
    test(
        'deve retornar AuthException com mensagem de credenciais inválidas quando code for invalid-credential',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: InvalidCredentialsException,
        errorCode: FirebaseAuthErrorCodes.invalidCredential,
        expectedMessage: AuthErrorMessages.invalidCredentials,
      );
    });

    // Testa o código 'user-not-found'
    test(
        'deve retornar AuthException com mensagem de usuário não existe quando code for user-not-found',
        () {
      const errorCode = 'user-not-found';
      const message = 'Usuário não existe';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o código 'user-disabled'
    test(
        'deve retornar AuthException com mensagem de conta desativada quando code for user-disabled',
        () {
      const errorCode = 'user-disabled';
      const message = 'Conta desativada';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o código 'email-already-in-use'
    test(
        'deve retornar AuthException com mensagem de email em uso quando code for email-already-in-use',
        () {
      const errorCode = 'email-already-in-use';
      const message = 'E-mail já está em uso';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o código 'network-request-failed'
    test(
        'deve retornar AuthException com mensagem de falha na rede quando code for network-request-failed',
        () {
      const errorCode = 'network-request-failed';
      const message = 'Erro de falha na rede';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o código 'invalid-user-token'
    test(
        'deve retornar AuthException com mensagem de token inválido quando code for invalid-user-token',
        () {
      const errorCode = 'invalid-user-token';
      const message = 'Token de autenticação inválido';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o código internal-error
    test(
        'deve retornar AuthException com mensagem de serviço indisponível quando code for internal-error',
        () {
      const errorCode = 'internal-error';
      const message = 'Firebase está indisponível';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o código weak-password
    test(
        'deve retornar AuthException com mensagem de senha fraca quando code for weak-password',
        () {
      const errorCode = 'weak-password';
      const message =
          'A senha é muito fraca. Escolha uma senha com pelo menos 6 caracteres';

      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthException,
        errorCode: errorCode,
        expectedMessage: message,
      );
    });

    // Testa o caso padrão quando o código não é tratado explicitamente
    test('deve retornar AuthException genérica no caso default', () {
      const errorCode = 'unknown-error';
      const message = 'Erro de autenticação: Algo deu errado';

      // Arrange
      final error =
          FirebaseAuthException(code: errorCode, message: 'Algo deu errado');

      // Act
      final result = fromFirebaseAuthExceptionMapper(error);

      // Assert
      expect(result, isA<AuthException>());
      expect(result.message, message);
      expect(result.code, errorCode);
    });
  });
}
