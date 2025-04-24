import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/get_user_stream_from_google_usecase.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GetUserStreamFromGoogleUseCase usecase;
  late MockGoogleAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockGoogleAuthRepository();
    usecase = GetUserStreamFromGoogleUseCase(mockRepository);
  });

  group('GetUserStreamFromGoogleUsecase', () {
    group('casos de sucesso', () {
      test(
          'deve chamar userStream no GoogleAuthRepository e retornar um Stream<User>',
          () async {
        final user = UserAuth(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          photoUrl: 'https://example.com/photo.jpg',
        );
        final userStream = Stream<UserAuth>.value(user);
        when(mockRepository.userStream).thenAnswer((_) => userStream);

        final result = usecase.fetch();

        await expectLater(result, emitsInOrder([user]));
        verify(mockRepository.userStream);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
