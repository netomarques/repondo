import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_email_notifier.g.dart';

@riverpod
class SignOutEmailNotifier extends _$SignOutEmailNotifier {
  EmailAuthFacade get _emailAuthFacade => ref.read(emailAuthFacadeProvider);

  @override
  Future<void> build() async {}

  Future<void> signOut() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _emailAuthFacade.signOut();
      return result.fold(
        (error) => throw error,
        (_) => null,
      );
    });
  }
}
