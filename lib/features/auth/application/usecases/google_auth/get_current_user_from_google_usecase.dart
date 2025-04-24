import 'package:repondo/features/auth/domain/exports.dart';

class GetCurrentUserFromGoogleUseCase {
  final GoogleAuthRepository _repository;

  GetCurrentUserFromGoogleUseCase(this._repository);

  Future<UserAuth> fetch() => _repository.getCurrentUser();
}
