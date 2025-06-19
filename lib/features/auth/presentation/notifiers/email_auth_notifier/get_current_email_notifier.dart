import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_email_notifier.g.dart';

@riverpod
class GetCurrentEmailNotifier extends _$GetCurrentEmailNotifier {
  EmailAuthFacade get _emailAuthFacade => ref.read(emailAuthFacadeProvider);

  @override
  Future<UserAuth?> build() async {
    final result = await _emailAuthFacade.getCurrentUser();

    return result.fold((error) => throw error, (userAuth) => userAuth);
  }
}
