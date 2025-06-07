import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/features/auth/application/auth_redirect_logic.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/router/auth_route_locations.dart';

import '../mocks/user_auth_test_factory.dart';

void main() {
  group('authRedirectLogic', () {
    late UserAuth testUser;

    setUp(() {
      // Cria um usuário de teste
      testUser = UserAuthTestFactory.create();
    });

    group('casos de sucesso', () {
      test(
          'deve redirecionar para ${AuthRouteLocations.home} quando usuário estiver autenticado e rota atual for diferente de ${AuthRouteLocations.home}',
          () async {
        // Act
        final result = authRedirectLogic(
          authState: AsyncData(testUser),
          currentLocation: '/rota_diferente',
        );

        // Assert
        expect(result, equals(AuthRouteLocations.home));
      });

      test(
          'deve retornar null se já estiver na rota ${AuthRouteLocations.home} e usuário estiver autenticado',
          () {
        // Act
        final result = authRedirectLogic(
          authState: AsyncData(testUser),
          currentLocation: AuthRouteLocations.home,
        );

        //Assert
        expect(result, isNull);
      });
      test(
          'deve redirecionar para ${AuthRouteLocations.login} quando usuário for null e rota atual for diferente de ${AuthRouteLocations.login}',
          () async {
        // Act
        final result = authRedirectLogic(
          authState: AsyncData(null),
          currentLocation: '/rota_diferente',
        );

        // Assert
        expect(result, equals(AuthRouteLocations.login));
      });

      test(
          'deve retornar null se já estiver na rota ${AuthRouteLocations.login} e usuário for null',
          () {
        // Act
        final result = authRedirectLogic(
          authState: AsyncData(null),
          currentLocation: AuthRouteLocations.login,
        );

        //Assert
        expect(result, isNull);
      });
    });

    group('casos de erro', () {
      test(
          'deve redirecionar para ${AuthRouteLocations.conta_desativada} se erro for conta desativada e rota atual for diferente de ${AuthRouteLocations.conta_desativada}',
          () {
        // Act
        final result = authRedirectLogic(
          authState:
              AsyncError(AuthException('Conta desativada'), StackTrace.empty),
          currentLocation: '/rota_diferente',
        );

        // Assert
        expect(result, AuthRouteLocations.conta_desativada);
      });
      test(
          'deve retornar null se erro for conta desativada e rota atual for ${AuthRouteLocations.conta_desativada}',
          () {
        // Act
        final result = authRedirectLogic(
          authState:
              AsyncError(AuthException('Conta desativada'), StackTrace.empty),
          currentLocation: AuthRouteLocations.conta_desativada,
        );

        // Assert
        expect(result, isNull);
      });
      test(
          'deve redirecionar para ${AuthRouteLocations.login} se erro for genérico e rota atual for diferente de ${AuthRouteLocations.login}',
          () {
        // Act
        final result = authRedirectLogic(
          authState: AsyncError(Exception('Erro genérico'), StackTrace.empty),
          currentLocation: '/rota_diferente',
        );

        // Assert
        expect(result, AuthRouteLocations.login);
      });
      test(
          'deve retornar null se erro for genérico e rota atual for ${AuthRouteLocations.login}',
          () {
        // Act
        final result = authRedirectLogic(
          authState: AsyncError(Exception('Erro genérico'), StackTrace.empty),
          currentLocation: AuthRouteLocations.login,
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('casos de loading', () {
      test(
          'deve redirecionar para ${AuthRouteLocations.splash} se estado for loading e rota atual for diferente de ${AuthRouteLocations.splash}',
          () {
        // Act
        final result = authRedirectLogic(
          authState: const AsyncLoading(),
          currentLocation: '/rota_diferente',
        );

        // Assert
        expect(result, AuthRouteLocations.splash);
      });
      test(
          'deve retornar null se estado for loading e rota atual for ${AuthRouteLocations.splash}',
          () {
        // Act
        final result = authRedirectLogic(
          authState: const AsyncLoading(),
          currentLocation: AuthRouteLocations.splash,
        );

        // Assert
        expect(result, isNull);
      });
    });
  });
}
