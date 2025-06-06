import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/providers/facades/email_auth_facade_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redirect_observe_user_auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class RedirectObserveUserAuthNotifier
    extends _$RedirectObserveUserAuthNotifier {
  Stream<Result<UserAuth?, AuthException>> get _observeUserAuth =>
      ref.watch(emailAuthFacadeProvider).observeUserAuth;

  @override
  Stream<UserAuth?> build() {
    return _observeUserAuth.asyncMap(
      (result) => result.fold(
        (error) => throw error,
        (userAuth) => userAuth,
      ),
    );
  }
}
