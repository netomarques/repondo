import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/sign_out_from_google_usecase.dart';

import '../../../../../mocks/mocks.mocks.dart';

void main() {
  late MockGoogleAuthRepository mockRepository;
  late SignOutFromGoogleUseCase useCase;

  setUp(() {
    mockRepository = MockGoogleAuthRepository();
    useCase = SignOutFromGoogleUseCase(mockRepository);
  });

  group('SignOutFromGoogleUseCase', () {
    group('casos de sucesso', () {
      test('deve chamar signOut no GoogleAuthRepository', () async {
        when(mockRepository.signOut()).thenAnswer((_) async => Future.value());

        await useCase.execute();

        verify(mockRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
