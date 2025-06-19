import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_email_notifier.g.dart';

@riverpod
class SignUpEmailNotifier extends _$SignUpEmailNotifier {
  EmailAuthFacade get _emailAuthFacade => ref.read(emailAuthFacadeProvider);

  @override
  Future<UserAuth?> build() async => null;

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
}
