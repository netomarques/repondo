import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/get_current_user_from_google_usecase.dart';
import 'package:repondo/features/auth/domain/entities/user.dart';

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
        final user =
            User(id: '123', name: 'Test User', email: 'test@example.com');
        when(mockRepository.getCurrentUser()).thenAnswer((_) async => user);

        final result = await usecase.execute();

        expect(result, equals(user));
        verify(mockRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
