import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/data/repositories/firebase_anonymous_auth_repository.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';

late FirebaseAnonymousAuthRepository firebaseAnonymousAuthRepository;
late MockFirebaseAuth mockFirebaseAuth;
late MockUser mockUser;

void main() {
  group('FirebaseAnonymousAuthRepository', () {
    const userId = 'userId';
    const isAnonymous = true;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      firebaseAnonymousAuthRepository =
          FirebaseAnonymousAuthRepository(firebaseAuth: mockFirebaseAuth);

      // Configurando o mockUser para retornar um ID de usuário válido
      when(mockUser.uid).thenReturn(userId);
      when(mockUser.isAnonymous).thenReturn(isAnonymous);
      when(mockUser.email).thenReturn(null);
      when(mockUser.displayName).thenReturn(null);
      when(mockUser.photoURL).thenReturn(null);

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    group('getCurrentUser', () {
      group('casos de sucesso', () {
        test(
            'deve retornar UserAuth válido quando user do FirebaseAuth não for null',
            () async {
          // Act
          final result = await firebaseAnonymousAuthRepository.getCurrentUser();

          // Assert
          // Verifica se o resultado foi um sucesso contendo um UserAuth
          expect(result, isA<Success<UserAuth?, AuthException>>());
          expect(result.data, isNotNull,
              reason: 'UserAuth não deveria ser null');

          final userAuth = result.data!;
          // Verifica os campos do UserAuth
          expect(userAuth.id, userId);
          expect(userAuth.isAnonymous, isTrue,
              reason: 'isAnonymous não deveria ser false');
          expect(userAuth.email, isNull);
          expect(userAuth.name, isNull);
          expect(userAuth.photoUrl, isNull);

          // Verifica que a propriedade currentUser foi chamada uma vez
          verify(mockFirebaseAuth.currentUser).called(1);
          // Garante que nenhuma outra chamada inesperada foi feita
          verifyNoMoreInteractions(mockFirebaseAuth);
        });

        test('deve retornar UserAuth null quando user do FirebaseAuth for null',
            () async {
          // Arrange
          when(mockFirebaseAuth.currentUser).thenReturn(null);

          // Act
          final result = await firebaseAnonymousAuthRepository.getCurrentUser();

          // Assert
          // Verifica se o resultado foi um sucesso contendo um UserAuth
          expect(result, isA<Success<UserAuth?, AuthException>>());
          expect(result.data, isNull, reason: 'UserAuth deveria ser null');

          verify(mockFirebaseAuth.currentUser).called(1);
          verifyNoMoreInteractions(mockFirebaseAuth);
        });
      });
    });
  });
}
