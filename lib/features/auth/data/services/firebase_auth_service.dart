import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/core/log/app_logger.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/data/mappers/exports.dart';
import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final AppLogger _logger;

  FirebaseAuthService({FirebaseAuth? firebaseAuth, required AppLogger logger})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _logger = logger;

  @override
  Future<Result<UserAuth?, AuthException>> getCurrentUser() {
    _logger.info('[getCurrentUser] Iniciando verificação do usuário atual...');
    return Future.value(
      runCatchingSync(() {
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          _logger.warning('[getCurrentUser] Usuário atual é null');
          return null;
        }
        _logger
            .info('[getCurrentUser] Usuário atual encontrado: uid=${user.uid}');

        return user.toUserAuth();
      }, (error) {
        _logger.error('[getCurrentUser] Erro ao obter usuário atual', error,
            StackTrace.current);
        return AuthException(AuthErrorMessages.authVerificationError);
      }),
    );
  }

  @override
  Future<Result<bool, AuthException>> isAuthenticated() {
    _logger.info('[isAuthenticated] Iniciando verificação de autenticação...');
    return Future.value(
      runCatchingSync(
        () {
          final userIsAuthenticated = _firebaseAuth.currentUser != null;
          _logger.info('[isAuthenticated] Resultado: $userIsAuthenticated');
          return userIsAuthenticated;
        },
        (error) {
          _logger.error('[isAuthenticated] Erro ao verificar autenticação',
              error, StackTrace.current);
          return AuthException(AuthErrorMessages.authVerificationError);
        },
      ),
    );
  }

  @override
  Stream<Result<UserAuth?, AuthException>> get userStream =>
      _firebaseAuth.authStateChanges().map(
        (user) {
          _logger
              .info('[userStream] Novo evento de autenticação recebido: $user');
          return runCatchingSync(
            () => user?.toUserAuth(),
            (error) {
              _logger.error('[userStream] Erro ao mapear usuário para UserAuth',
                  error, StackTrace.current);
              return AuthException(AuthErrorMessages.authVerificationError);
            },
          );
        },
      );
}
