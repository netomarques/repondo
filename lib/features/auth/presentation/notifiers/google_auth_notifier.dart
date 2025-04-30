import 'package:repondo/features/auth/application/facades/google_auth_facade.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/providers/facades/google_auth_facade_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_notifier.g.dart';

@riverpod
class GoogleAuthNotifier extends _$GoogleAuthNotifier {
  GoogleAuthFacade get _authFacade => ref.read(googleAuthFacadeProvider);

  @override
  Future<UserAuth> build() async {
    try {
      final userAuthenticated = await _authFacade.getCurrentUser();

      if (userAuthenticated == null) {
        throw AuthException('User not authenticated');
      }

      return userAuthenticated;
    } catch (e, st) {
      throw AsyncError(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _authFacade.signInWithGoogle());
  }

  Future<void> signOut() async {
    await _authFacade.signOut();
    ref.invalidateSelf(); // força o rebuild e chama o build() de novo
  }
}
