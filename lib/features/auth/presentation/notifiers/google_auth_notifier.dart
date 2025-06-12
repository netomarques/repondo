import 'package:repondo/features/auth/application/facades/google_auth_facade.dart';
import 'package:repondo/features/auth/application/providers/facades/google_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_notifier.g.dart';

@riverpod
class GoogleAuthNotifier extends _$GoogleAuthNotifier {
  GoogleAuthFacade get _authFacade => ref.read(googleAuthFacadeProvider);

  @override
  Future<UserAuth> build() async {
    final userAuthenticated = await _authFacade.getCurrentUser();

    return userAuthenticated ??
        (throw AuthException('Usuário não autenticado'));
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final userAuth = await _authFacade.getCurrentUser();
      return userAuth ?? await _authFacade.signInWithGoogle();
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    try {
      final userAuth = await _authFacade.getCurrentUser();
      if (userAuth == null) {
        throw AuthException('Não existe mais usuário autenticado');
      }

      await _authFacade.signOut();
      ref.invalidateSelf(); // força o rebuild e chama o build() de novo
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
