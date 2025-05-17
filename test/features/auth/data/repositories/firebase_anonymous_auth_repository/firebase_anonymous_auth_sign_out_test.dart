import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/data/repositories/firebase_anonymous_auth_repository.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

late FirebaseAnonymousAuthRepository firebaseAnonymousAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;

void main() {
  group('FirebaseAnonymousAuthRepository', () {
    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();

      firebaseAnonymousAuthRepository =
          FirebaseAnonymousAuthRepository(firebaseAuth: mockFirebaseAuth);
    });

    group('signOut', () {
      group('casos de sucesso', () {
        test(
            'deve retornar Success<void, AuthException> quando logout ocorrer sem erro',
            () async {
          // Arrange
          when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

          // Act
          final result = await firebaseAnonymousAuthRepository.signOut();

          // Assert
          expect(result, isA<Success<void, AuthException>>());

          verify(mockFirebaseAuth.signOut()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });

      group('casos de erro', () {
        test(
            'deve retornar Failure<void, AuthException> quando logout ocorrer um erro de FirebaseAuthException',
            () async {
          const errorCode = 'unknown-error';
          const message = 'Erro desconhecido';

          // Arrange
          when(mockFirebaseAuth.signOut()).thenThrow(
              FirebaseAuthException(code: errorCode, message: message));

          // Act
          final result = await firebaseAnonymousAuthRepository.signOut();

          // Assert
          expect(result, isA<Failure<void, AuthException>>());

          final failure = result.error!;
          expect(failure.message, contains(message));
          expect(failure.code, errorCode);

          verify(mockFirebaseAuth.signOut()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test(
            'deve retornar Failure<void, AuthException> quando logout ocorrer um erro genérico',
            () async {
          const message = 'Erro no logout';

          // Arrange
          when(mockFirebaseAuth.signOut())
              .thenThrow(Exception('Erro desconhecido'));

          // Act
          final result = await firebaseAnonymousAuthRepository.signOut();

          // Assert
          expect(result, isA<Failure<void, AuthException>>());

          final failure = result.error!;
          expect(failure.message, contains(message));

          verify(mockFirebaseAuth.signOut()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
