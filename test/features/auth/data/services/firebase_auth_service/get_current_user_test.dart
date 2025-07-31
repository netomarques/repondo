// Instâncias utilizadas em todos os testes
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/data/services/firebase_auth_service.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

late FirebaseAuthService authService;
late MockFirebaseAuth mockFirebaseAuth;
late MockUserCredential mockUserCredential;
late MockAppLogger mockLogger;
late MockUser mockUser;

/// Função auxiliar para validar se o resultado foi um sucesso com um [UserAuth]
/// e se os campos estão de acordo com o esperado
void _expectSuccessUserAuthResult({
  required Result<UserAuth?, AuthException> result,
  required String expectedId,
  required String? expectedEmail,
  required String? expectedName,
  required String? expectedPhotoUrl,
}) {
  // Verifica se o resultado foi um sucesso contendo um UserAuth
  expect(result, isA<Success<UserAuth?, AuthException>>());
  expect(result.data, isNotNull, reason: 'UserAuth não deveria ser null');

  final userAuth = result.data!;
  // Verifica os campos do UserAuth
  expect(userAuth.id, expectedId);
  expect(userAuth.email, expectedEmail);
  expect(userAuth.name, expectedName);
  expect(userAuth.photoUrl, expectedPhotoUrl);

  // Verifica que a propriedade currentUser foi chamada uma vez
  verify(mockFirebaseAuth.currentUser).called(1);
  // Garante que nenhuma outra chamada inesperada foi feita
  verifyNoMoreInteractions(mockFirebaseAuth);
}

void main() {
  group('FirebaseAuthService', () {
    const logStart = '[getCurrentUser] Iniciando verificação do usuário atual';
    const logWarningUserNull = '[getCurrentUser] Usuário atual é null';
    const logSuccess = '[getCurrentUser] Usuário atual encontrado';

    // Dados simulados do usuário
    const email = 'email@example.com';
    const userId = 'userId';
    const userName = 'User Name';
    const photoUrl = 'https://example.com/photo.jpg';
    const isAnonymous = false;

    setUp(() {
      // Inicialização dos mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      mockLogger = MockAppLogger();
      mockUser = MockUser();

      // Instância do repositório com o mock injetado
      authService = FirebaseAuthService(
          firebaseAuth: mockFirebaseAuth, logger: mockLogger);

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
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    group('getCurrentUser', () {
      group('casos de sucesso', () {
        test(
            'deve retornar UserAuth válido quando user do FirebaseAuth não for null',
            () async {
          final result = await authService.getCurrentUser();

          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: email,
            expectedName: userName,
            expectedPhotoUrl: photoUrl,
          );

          verifyInOrder([
            mockLogger.info(argThat(contains(logStart))),
            mockLogger.info(argThat(contains(logSuccess))),
          ]);

          verifyNoMoreInteractions(mockLogger);
        });

        test('deve retornar UserAuth válido com campos nulos', () async {
          // Arrange
          when(mockUser.email).thenReturn(null);
          when(mockUser.displayName).thenReturn(null);
          when(mockUser.photoURL).thenReturn(null);

          // Act
          final result = await authService.getCurrentUser();

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: null,
            expectedName: null,
            expectedPhotoUrl: null,
          );
          verifyInOrder([
            mockLogger.info(argThat(contains(logStart))),
            mockLogger.info(argThat(contains(logSuccess))),
          ]);

          verifyNoMoreInteractions(mockLogger);
        });

        test('deve retornar UserAuth válido quando somente email for null',
            () async {
          // Arrange
          when(mockUser.email).thenReturn(null);

          // Act
          final result = await authService.getCurrentUser();

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: null,
            expectedName: userName,
            expectedPhotoUrl: photoUrl,
          );
        });

        test('deve retornar UserAuth válido quando somente name for null',
            () async {
          // Arrange
          when(mockUser.displayName).thenReturn(null);

          // Act
          final result = await authService.getCurrentUser();

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: email,
            expectedName: null,
            expectedPhotoUrl: photoUrl,
          );

          verifyInOrder([
            mockLogger.info(argThat(contains(logStart))),
            mockLogger.info(argThat(contains(logSuccess))),
          ]);

          verifyNoMoreInteractions(mockLogger);
        });

        test('deve retornar UserAuth válido quando somente photoUrl for null',
            () async {
          // Arrange
          when(mockUser.photoURL).thenReturn(null);

          // Act
          final result = await authService.getCurrentUser();

          // Assert
          _expectSuccessUserAuthResult(
            result: result,
            expectedId: userId,
            expectedEmail: email,
            expectedName: userName,
            expectedPhotoUrl: null,
          );

          verifyInOrder([
            mockLogger.info(argThat(contains(logStart))),
            mockLogger.info(argThat(contains(logSuccess))),
          ]);

          verifyNoMoreInteractions(mockLogger);
        });

        test('deve retornar UserAuth null quando user do FirebaseAuth for null',
            () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await authService.getCurrentUser();

          // Assert
          expect(result, isA<Success<UserAuth?, AuthException>>());
          expect(result.data, isNull, reason: 'UserAuth deveria ser null');

          verify(mockFirebaseAuth.currentUser).called(1);

          verifyInOrder([
            mockLogger.info(argThat(contains(logStart))),
            mockLogger.warning(argThat(contains(logWarningUserNull))),
          ]);

          verifyNoMoreInteractions(mockLogger);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
