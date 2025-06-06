import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/providers/facades/email_auth_facade_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_auth_notifier.g.dart';

@riverpod
class EmailAuthNotifier extends _$EmailAuthNotifier {
  EmailAuthFacade get _emailAuthFacade => ref.read(emailAuthFacadeProvider);

  @override
  Future<UserAuth?> build() async {
    final result = await _emailAuthFacade.getCurrentUser();

    return result.fold((error) => throw error, (userAuth) => userAuth);
  }

  Future<void> getCurrentUser() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _emailAuthFacade.getCurrentUser();
      return result.fold(
        (error) => throw error,
        (userAuth) {
          if (userAuth == null) {
            throw AuthException('Usuário não autenticado');
          }
          return userAuth;
        },
      );
    });
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _emailAuthFacade.signInWithEmail(email, password);
      return result.fold(
        (error) => throw error,
        (userAuth) => userAuth,
      );
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _emailAuthFacade.signUpWithEmail(email, password);
      return result.fold(
        (error) => throw error,
        (userAuth) => userAuth,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    final result = await _emailAuthFacade.signOut();

    result.fold(
      (error) => state = AsyncError(error, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}
