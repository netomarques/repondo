import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/data/services/firebase_auth_service.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  group('FirebaseAuthService - isAuthenticated', () {
    const logStart = '[isAuthenticated] Iniciando verificação de autenticação';
    const logSuccess = '[isAuthenticated] Resultado';
    const logError = '[isAuthenticated] Erro ao verificar autenticação';

    late MockFirebaseAuth mockFirebaseAuth;
    late MockAppLogger mockLogger;
    late FirebaseAuthService service;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockLogger = MockAppLogger();
      service = FirebaseAuthService(
        firebaseAuth: mockFirebaseAuth,
        logger: mockLogger,
      );
    });

    group('casos de sucesso', () {
      test('deve retornar true quando currentUser não for null', () async {
        final mockUser = MockUser();
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final result = await service.isAuthenticated();

        expect(result, isA<Success<bool, AuthException>>());
        expect(result.data, isTrue);

        verify(mockFirebaseAuth.currentUser).called(1);
        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
        ]);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('deve retornar false quando currentUser for null', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = await service.isAuthenticated();

        expect(result, isA<Success<bool, AuthException>>());
        expect(result.data, isFalse);

        verify(mockFirebaseAuth.currentUser).called(1);
        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
        ]);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });
    });

    group('casos de erro', () {
      test('deve retornar AuthException em caso de erro', () async {
        when(mockFirebaseAuth.currentUser).thenThrow(Exception('erro'));

        final result = await service.isAuthenticated();

        expect(result, isA<Failure<bool, AuthException>>());
        expect(result.error, isA<AuthException>());

        verify(mockFirebaseAuth.currentUser).called(1);
        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });
    });
  });
}
