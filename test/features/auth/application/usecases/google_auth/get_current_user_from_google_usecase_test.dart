import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/get_current_user_from_google_usecase.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  late GetCurrentUserFromGoogleUseCase usecase;
  late MockGoogleAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockGoogleAuthRepository();
    usecase = GetCurrentUserFromGoogleUseCase(mockRepository);
  });

  group('GetCurrentUserFromGoogleUseCase', () {
    group('casos de sucesso', () {
      test(
          'deve chamar getCurrentUser no GoogleAuthRepository e retornar um User',
          () async {
        final user = UserAuth(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          photoUrl: 'http://example.com/photo.jpg',
        );
        when(mockRepository.getCurrentUser()).thenAnswer((_) async => user);

        final result = await usecase.fetch();

        expect(result, equals(user));
        verify(mockRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test(
          'deve chamar getCurrentUser no GoogleAuthRepository e retornar null quando o usuário não estiver autenticado',
          () async {
        when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);

        final result = await usecase.fetch();

        expect(result, isNull);
        verify(mockRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
