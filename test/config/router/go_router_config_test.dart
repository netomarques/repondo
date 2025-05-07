import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/config/router/go_router_config.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/providers/facades/google_auth_facade_provider.dart';

import '../../mocks/mocks.mocks.dart';

late MockGoogleAuthFacade mockGoogleAuthFacade;
late ProviderContainer container;
late UserAuth testUser;

void main() {
  group('goRouterConfig', () {
    setUp(() {
      mockGoogleAuthFacade = MockGoogleAuthFacade();

      // Substitui o provider padrão pela versão mockada
      container = ProviderContainer(overrides: [
        googleAuthFacadeProvider.overrideWithValue(mockGoogleAuthFacade),
      ]);

      // Garante que o container seja descartado após o teste
      addTearDown(container.dispose);

      // Cria um usuário de teste
      testUser = UserAuth(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'http://example.com/photo.jpg',
      );

      // Configura comportamento padrão do mock
      when(mockGoogleAuthFacade.getCurrentUser())
          .thenAnswer((_) async => testUser);
    });

    test('deve redirecionar para /home quando autenticado', () async {
      final goRouter = container.read(goRouterConfigProvider);

      // final redirect =
      //     goRouter.redirect!(null, GoRouterState(uri: Uri.parse('/login')));

      // expect(redirect, AuthRouteLocations.home);
    });
  });
}
