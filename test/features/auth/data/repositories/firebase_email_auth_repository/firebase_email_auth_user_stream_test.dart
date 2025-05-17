import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/data/repositories/firebase_email_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/exports.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

// Instâncias utilizadas em todos os testes
late FirebaseEmailAuthRepository firebaseEmailAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;
late StreamController<User?> userController;
late MockUser mockUser;

void main() {
  group('FirebaseEmailAuthRepository', () {
    // Dados simulados do usuário
    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const isAnonymous = false;

    setUp(() {
      // Inicialização dos mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      userController = StreamController<User?>();

      // Fecha o StreamController após cada teste para evitar vazamentos
      addTearDown(userController.close);

      // Instância do repositório com o mock injetado
      firebaseEmailAuthRepository =
          FirebaseEmailAuthRepository(firebaseAuth: mockFirebaseAuth);

      // Configurando o mockUser para retornar um email válido
      // e um ID de usuário válido
      // e um email de usuário válido
      // e um nome de usuário válido
      // e uma URL de foto válida
      when(mockUser.uid).thenReturn(userId);
      when(mockUser.email).thenReturn(email);
      when(mockUser.displayName).thenReturn(userName);
      when(mockUser.photoURL).thenReturn(photoUrl);
      when(mockUser.isAnonymous).thenReturn(isAnonymous);

      // Faz o mockFirebaseAuth retornar a stream controlada pelo StreamController
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => userController.stream);
    });

    group('userStream', () {
      group('casos de sucesso', () {
        test(
            'deve emitir Success<UserAuth? , AuthException> com UserAuth válido quando usuário está autenticado',
            () async {
          // Arrange
          userController.add(mockUser);

          // Act
          final result = await firebaseEmailAuthRepository.userStream.first;

          // Assert
          expect(result, isA<Success<UserAuth?, AuthException>>());
          expect(result.data, isNotNull);

          final userAuth = result.data!;
          expect(userAuth.id, userId);
          expect(userAuth.email, email);
          expect(userAuth.name, userName);
          expect(userAuth.photoUrl, photoUrl);

          verify(mockFirebaseAuth.authStateChanges()).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
        test(
            'deve emitir Success<UserAuth? , AuthException> com UserAuth null quando usuário for null',
            () async {
          // Arrange
          userController.add(null);

          // Act
          final result = await firebaseEmailAuthRepository.userStream.first;

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
            firebaseEmailAuthRepository.userStream,
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
