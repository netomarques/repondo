import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/sign_in_with_google_usecase.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  late SignInWithGoogleUseCase usecase;
  late MockGoogleAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockGoogleAuthRepository();
    usecase = SignInWithGoogleUseCase(mockRepository);
  });

  group('SignInWithGoogleUsecase', () {
    group('casos de sucesso', () {
      test('deve chamar signIn no GoogleAuthRepository e retornar um User',
          () async {
        final expectedUser = UserAuth(
          id: '123',
          name: 'João',
          email: 'joao@email.com',
          photoUrl: 'https://example.com/photo.jpg',
        );
        when(mockRepository.signIn()).thenAnswer((_) async => expectedUser);

        final result = await usecase.execute();

        expect(result, equals(expectedUser));
        verify(mockRepository.signIn()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
