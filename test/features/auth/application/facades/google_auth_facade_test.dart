import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/application/facades/google_auth_facade.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late GoogleAuthFacade googleAuthFacade;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockSignOutFromGoogleUseCase mockSignOutFromGoogleUseCase;
  late MockGetCurrentUserFromGoogleUseCase mockGetCurrentUserUseCase;
  late MockGetUserStreamFromGoogleUseCase mockGetUserStreamUseCase;

  setUp(() {
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockSignOutFromGoogleUseCase = MockSignOutFromGoogleUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserFromGoogleUseCase();
    mockGetUserStreamUseCase = MockGetUserStreamFromGoogleUseCase();

    googleAuthFacade = GoogleAuthFacade(
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      signOutFromGoogleUseCase: mockSignOutFromGoogleUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      getUserStreamUseCase: mockGetUserStreamUseCase,
    );
  });

  group('GoogleAuthFacade', () {
    test(
        'deve chamar execute() do SignInWithGoogleUseCase quando signInWithGoogle é chamado',
        () async {
      final user = UserAuth(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'http://example.com/photo.jpg',
      );
      when(mockSignInWithGoogleUseCase.execute()).thenAnswer((_) async => user);

      final result = await googleAuthFacade.signInWithGoogle();

      expect(result, user);
      verify(mockSignInWithGoogleUseCase.execute()).called(1);
      verifyNoMoreInteractions(mockSignInWithGoogleUseCase);
    });

    test(
        'deve chamar execute() do SignOutFromGoogleUseCase quando signOutFromGoogle é chamado',
        () async {
      await googleAuthFacade.signOut();

      verify(mockSignOutFromGoogleUseCase.execute()).called(1);
      verifyNoMoreInteractions(mockSignOutFromGoogleUseCase);
    });

    test(
        'deve chamar fetch() do GetCurrentUserFromGoogleUseCase quando getCurrentUser é chamado',
        () async {
      final user = UserAuth(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'http://example.com/photo.jpg',
      );
      when(mockGetCurrentUserUseCase.fetch()).thenAnswer((_) async => user);

      final result = await googleAuthFacade.getCurrentUser();

      expect(result, user);
      verify(mockGetCurrentUserUseCase.fetch()).called(1);
      verifyNoMoreInteractions(mockGetCurrentUserUseCase);
    });

    test(
        'deve chamar fetch() do GetUserStreamFromGoogleUseCase quando getCurrentUser é chamado',
        () async {
      final userStream = Stream<UserAuth>.fromIterable([
        UserAuth(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          photoUrl: 'http://example.com/photo.jpg',
        ),
      ]);
      when(mockGetUserStreamUseCase.fetch()).thenAnswer((_) => userStream);

      final result = googleAuthFacade.observeUserStream();

      await expectLater(
          result,
          emitsInOrder([
            isA<UserAuth>()
                .having((user) => user.id, 'id', '123')
                .having((user) => user.name, 'name', 'Test User')
                .having((user) => user.email, 'email', 'test@example.com')
                .having((user) => user.photoUrl, 'photoUrl',
                    'http://example.com/photo.jpg'),
          ]));

      verify(mockGetUserStreamUseCase.fetch()).called(1);
      verifyNoMoreInteractions(mockGetUserStreamUseCase);
    });
  });
}
