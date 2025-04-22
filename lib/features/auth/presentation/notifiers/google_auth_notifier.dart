import 'package:repondo/features/auth/application/facades/google_auth_facade.dart';
import 'package:repondo/features/auth/providers/facades/google_auth_facade_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_notifier.g.dart';

@riverpod
class GoogleAuthNotifier extends _$GoogleAuthNotifier {
  late final GoogleAuthFacade _authFacade;

  @override
  AsyncValue<void> build() {
    _authFacade = ref.watch(googleAuthFacadeProvider);
    return const AsyncData(null);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _authFacade.signInWithGoogle());
  }
}
