import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/data/repositories/firebase_anonymous_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

late FirebaseAnonymousAuthRepository firebaseAnonymousAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;
late StreamController<User?> userController;
late MockUser mockUser;

void main() {
  group('FirebaseAnonymousAuthRepository', () {
    const userId = 'userId';
    const isAnonymous = true;

    setUp(() {
      // Inicialização dos mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      userController = StreamController<User?>();

      // Fecha o StreamController após cada teste para evitar vazamentos
      addTearDown(userController.close);

      // Instância do repositório com o mock injetado
      firebaseAnonymousAuthRepository =
          FirebaseAnonymousAuthRepository(firebaseAuth: mockFirebaseAuth);

      // Configurando o mockUser para retornar um ID de usuário válido
      when(mockUser.uid).thenReturn(userId);
      when(mockUser.isAnonymous).thenReturn(isAnonymous);
      when(mockUser.email).thenReturn(null);
      when(mockUser.displayName).thenReturn(null);
      when(mockUser.photoURL).thenReturn(null);

      // Faz o mockFirebaseAuth retornar a stream controlada pelo StreamController
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => userController.stream);
    });

    group('userStream', () {
      group('casos de sucesso', () {
        test(
            'deve emitir Success<UserAuth?, AuthException> com UserAuth válido quando usuário está autenticado',
            () async {
          // Arrange
          userController.add(mockUser);

          // Act
          final result = await firebaseAnonymousAuthRepository.userStream.first;

          // Assert
          expect(result, isA<Success<UserAuth?, AuthException>>());
          expect(result.data, isNotNull);

          final userAuth = result.data!;
          expect(userAuth.id, userId);
          expect(userAuth.email, isNull);
          expect(userAuth.name, isNull);
          expect(userAuth.photoUrl, isNull);

          verify(mockFirebaseAuth.authStateChanges()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test(
            'deve emitir Success<UserAuth?, AuthException> com UserAuth null quando usuário for null',
            () async {
          // Arrange
          userController.add(null);

          // Act
          final result = await firebaseAnonymousAuthRepository.userStream.first;

          // Assert
          expect(result, isA<Success<UserAuth?, AuthException>>());
          expect(result.data, isNull);

          verify(mockFirebaseAuth.authStateChanges()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test(
            'deve emitir Success<UserAuth?, AuthException> com UserAuth válido seguido de Success com null quando usuário se torna null',
            () async {
          // Arrange & Act
          // Prepara a verificação do fluxo emitido, aguardando as emissões
          userController.add(mockUser);
          userController.add(null);

          await expectLater(
            firebaseAnonymousAuthRepository.userStream,
            emitsInOrder([
              isA<Success>().having((r) => r.data, 'data', isNotNull),
              isA<Success>().having((r) => r.data, 'data', isNull),
            ]),
          );
          
          verify(mockFirebaseAuth.authStateChanges()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
