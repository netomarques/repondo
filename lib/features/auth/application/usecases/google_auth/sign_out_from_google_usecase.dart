import 'package:repondo/features/auth/domain/exports.dart';

class SignOutFromGoogle {
  final GoogleAuthRepository repository;

  SignOutFromGoogle(this.repository);

  Future<void> execute() {
    return repository.signOut();
  }
}
