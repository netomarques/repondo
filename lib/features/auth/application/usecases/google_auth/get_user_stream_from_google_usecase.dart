import 'package:repondo/features/auth/domain/exports.dart';

class GetUserStreamFromGoogleUseCase {
  final GoogleAuthRepository _repository;

  GetUserStreamFromGoogleUseCase(this._repository);

  Stream<UserAuth> fetch() => _repository.userStream;
}
