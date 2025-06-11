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
  expect(result, isA<AuthException>(),
      reason: 'Deveria retornar uma exceção subclasse de AuthException');
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
      _expectFirebaseAuthExceptionMapping(
        exceptionType: UserNotFoundException,
        errorCode: FirebaseAuthErrorCodes.userNotFound,
        expectedMessage: AuthErrorMessages.userNotFound,
      );
    });

    // Testa o código 'user-disabled'
    test(
        'deve retornar AuthException com mensagem de conta desativada quando code for user-disabled',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: UserDisabledException,
        errorCode: FirebaseAuthErrorCodes.userDisabled,
        expectedMessage: AuthErrorMessages.userDisabled,
      );
    });

    // Testa o código 'email-already-in-use'
    test(
        'deve retornar AuthException com mensagem de email em uso quando code for email-already-in-use',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: EmailAlreadyInUseException,
        errorCode: FirebaseAuthErrorCodes.emailAlreadyInUse,
        expectedMessage: AuthErrorMessages.emailAlreadyInUse,
      );
    });

    // Testa o código 'network-request-failed'
    test(
        'deve retornar AuthException com mensagem de falha na rede quando code for network-request-failed',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: NetworkRequestFailedException,
        errorCode: FirebaseAuthErrorCodes.networkRequestFailed,
        expectedMessage: AuthErrorMessages.networkRequestFailed,
      );
    });

    // Testa o código 'invalid-user-token'
    test(
        'deve retornar AuthException com mensagem de token inválido quando code for invalid-user-token',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: InvalidUserTokenException,
        errorCode: FirebaseAuthErrorCodes.invalidUserToken,
        expectedMessage: AuthErrorMessages.invalidUserToken,
      );
    });

    // Testa o código internal-error
    test(
        'deve retornar AuthException com mensagem de serviço indisponível quando code for internal-error',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: InternalErrorException,
        errorCode: FirebaseAuthErrorCodes.internalError,
        expectedMessage: AuthErrorMessages.internalError,
      );
    });

    // Testa o código weak-password
    test(
        'deve retornar AuthException com mensagem de senha fraca quando code for weak-password',
        () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: WeakPasswordException,
        errorCode: FirebaseAuthErrorCodes.weakPassword,
        expectedMessage: AuthErrorMessages.weakPassword,
      );
    });

    // Testa o caso padrão quando o código não é tratado explicitamente
    test('deve retornar AuthException genérica no caso default', () {
      _expectFirebaseAuthExceptionMapping(
        exceptionType: AuthUnknownException,
        errorCode: FirebaseAuthErrorCodes.authUnknownError,
        expectedMessage: AuthErrorMessages.authUnknownError,
      );
    });
  });
}
