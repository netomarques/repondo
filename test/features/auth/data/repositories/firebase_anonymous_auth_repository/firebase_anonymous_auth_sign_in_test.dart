import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/exports.dart';
import 'package:repondo/features/auth/data/repositories/firebase_anonymous_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

late FirebaseAnonymousAuthRepository firebaseAnonymousAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;
late MockUserCredential mockUserCredential;
late MockUser mockUser;

void main() {
  group('FirebaseAnonymousAuthRepository', () {
    const userId = 'userId';
    const isAnonymous = true;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();

      firebaseAnonymousAuthRepository =
          FirebaseAnonymousAuthRepository(firebaseAuth: mockFirebaseAuth);

      // Configurando o mockUser para retornar um ID de usuário válido
      when(mockUser.uid).thenReturn(userId);
      when(mockUser.isAnonymous).thenReturn(isAnonymous);
      when(mockUser.email).thenReturn(null);
      when(mockUser.displayName).thenReturn(null);
      when(mockUser.photoURL).thenReturn(null);
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => mockUserCredential);
    });

    group('signInWithAnonymous', () {
      group('casos de sucesso', () {
        test(
            'deve retornar Success<UserAuth, AuthException> com UserAuth válido',
            () async {
          // Act
          final result =
              await firebaseAnonymousAuthRepository.signInWithAnonymous();

          // Assert
          expect(result, isA<Success<UserAuth, AuthException>>());

          final userAuth = result.data!;
          expect(userAuth.id, userId);
          expect(userAuth.isAnonymous, isTrue);
          expect(userAuth.email, isNull);
          expect(userAuth.name, isNull);
          expect(userAuth.photoUrl, isNull);
          verify(mockFirebaseAuth.signInAnonymously()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });

      group('casos de erro', () {
        test(
            'deve retornar Failure<UserAuth, AuthException> ao lançar uma exceção quando User for null',
            () async {
          const errorMessage = 'Após o login usuário é null';

          // Arrange
          when(mockUserCredential.user).thenReturn(null);

          // Act
          final result =
              await firebaseAnonymousAuthRepository.signInWithAnonymous();

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());

          final error = result.error!;
          expect(error.message, contains(errorMessage));

          verify(mockFirebaseAuth.signInAnonymously()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
        test(
            'deve retornar Failure<UserAuth, AuthException> ao lançar uma exceção do FirebaseAuthException',
            () async {
          const errorMessage = 'Erro desconhecido';
          const errorCode = 'unknowm';

          // Arrange
          when(mockFirebaseAuth.signInAnonymously()).thenThrow(
              FirebaseAuthException(code: errorCode, message: errorMessage));

          // Act
          final result =
              await firebaseAnonymousAuthRepository.signInWithAnonymous();

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());

          final error = result.error!;
          expect(error.code, errorCode);
          expect(error.message, contains(errorMessage));

          verify(mockFirebaseAuth.signInAnonymously()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test(
            'deve retornar Failure<UserAuth, AuthException> ao lançar uma exceção genérica',
            () async {
          const errorMessage = 'Erro genérico';

          // Arrange
          when(mockFirebaseAuth.signInAnonymously())
              .thenThrow(Exception(errorMessage));

          // Act
          final result =
              await firebaseAnonymousAuthRepository.signInWithAnonymous();

          // Assert
          expect(result, isA<Failure<UserAuth, AuthException>>());

          final error = result.error!;
          expect(error.message, contains(errorMessage));

          verify(mockFirebaseAuth.signInAnonymously()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
