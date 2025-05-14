import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

AuthException fromFirebaseAuthExceptionMapper(FirebaseAuthException error) {
  switch (error.code) {
    case 'wrong-password':
    case 'invalid-email':
      return AuthException('Credenciais inválidas', code: error.code);
    case 'user-not-found':
      return AuthException('Usuário não existe', code: error.code);
    case 'user-disabled':
      return AuthException('Conta desativada', code: error.code);
    case 'email-already-in-use':
      return AuthException('E-mail já está em uso', code: error.code);
    case 'network-request-failed':
      return AuthException('Erro de falha na rede', code: error.code);
    case 'invalid-user-token':
      return AuthException('Token de autenticação inválido', code: error.code);
    case 'internal-error':
      return AuthException('Firebase está indisponível', code: error.code);
    case 'weak-password':
      return AuthException(
          'A senha é muito fraca. Escolha uma senha com pelo menos 6 caracteres',
          code: error.code);
    default:
      return AuthException('Erro de autenticação: ${error.message}',
          code: error.code);
  }
}
