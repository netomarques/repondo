import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/application/auth_redirect_logic.dart';
import 'package:repondo/features/auth/presentation/providers/redirect_observe_user_auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_redirect_provider.g.dart';

/// Provider que retorna uma função de redirecionamento para o GoRouter.
@riverpod
GoRouterRedirect goRouterRedirect(Ref ref) {
  final authState = ref.watch(redirectObserveUserAuthNotifierProvider);

  return (BuildContext context, GoRouterState state) {
    return authRedirectLogic(
      authState: authState,
      currentLocation: state.matchedLocation,
    );
  };
}
