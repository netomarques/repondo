import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/providers/repositories/google_auth_repository_provider.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/get_current_user_from_google_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_user_from_google_provider.g.dart';

@riverpod
GetCurrentUserFromGoogleUseCase getCurrentUserFromGoogle(Ref ref) {
  final repository = ref.read(googleAuthRepositoryProvider);
  return GetCurrentUserFromGoogleUseCase(repository);
}
