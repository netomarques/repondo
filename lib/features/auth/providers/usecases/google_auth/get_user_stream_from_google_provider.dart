import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/get_user_stream_from_google_usecase.dart';
import 'package:repondo/features/auth/providers/repositories/google_auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_stream_from_google_provider.g.dart';

@riverpod
GetUserStreamFromGoogleUseCase getUserStreamFromGoogle(Ref ref) {
  final repository = ref.read(googleAuthRepositoryProvider);
  return GetUserStreamFromGoogleUseCase(repository);
}
