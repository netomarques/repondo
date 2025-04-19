import 'package:repondo/features/auth/domain/entities/user.dart';
import 'package:repondo/features/auth/domain/repositories/google_auth_repository.dart';

class GetCurrentUserFromGoogleUsecase {
  final GoogleAuthRepository repository;

  GetCurrentUserFromGoogleUsecase(this.repository);

  Future<User?> execute() {
    return repository.getCurrentUser();
  }
}
