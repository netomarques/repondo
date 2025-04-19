import 'package:repondo/features/auth/domain/repositories/exports.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> execute() => repository.signOut();
}
