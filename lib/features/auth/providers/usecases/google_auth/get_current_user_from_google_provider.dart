import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/get_current_user_from_google_usecase.dart';
import 'package:repondo/features/auth/providers/repositories/google_auth_repository_provider.dart';

final getCurrentUserFromGoogleProvider =
    Provider<GetCurrentUserFromGoogleUseCase>((ref) {
  return GetCurrentUserFromGoogleUseCase(
      ref.read(googleAuthRepositoryProvider));
});
