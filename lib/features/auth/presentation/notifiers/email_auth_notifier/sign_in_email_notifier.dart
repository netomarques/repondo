import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_email_notifier.g.dart';

@riverpod
class SignInEmailNotifier extends _$SignInEmailNotifier {
  EmailAuthFacade get _emailAuthFacade => ref.read(emailAuthFacadeProvider);

  @override
  Future<UserAuth?> build() async => null;

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
}
