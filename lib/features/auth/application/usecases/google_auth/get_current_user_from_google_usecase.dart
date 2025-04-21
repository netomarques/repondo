import 'package:repondo/features/auth/domain/exports.dart';

class GetCurrentUserFromGoogleUseCase {
  final GoogleAuthRepository _repository;

  GetCurrentUserFromGoogleUseCase(this._repository);

  Future<User> execute() => _repository.getCurrentUser();
}
