import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/config/router/app_routes.dart';
import 'package:repondo/features/auth/presentation/router/auth_routes.dart';

void main() {
  group('AppRoutes', () {
    // Testa se todas as rotas definidas em AuthRoutes estão presentes em AppRoutes
    test('deve incluir todas as rotas de AuthRoutes em AppRoutes', () {
      for (final route in AuthRoutes.routes) {
        // Verifica se existe uma rota em AppRoutes com o mesmo path
        final existsInAppRoutes =
            AppRoutes.routes.any((r) => r.path == route.path);

        // Garante que a rota foi incluída corretamente
        expect(
          existsInAppRoutes,
          isTrue,
          reason: 'A rota ${route.path} não está incluída em AppRoutes',
        );
      }
    });
  });
}
