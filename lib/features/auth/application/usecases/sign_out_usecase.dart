import 'package:repondo/features/auth/domain/repositores/exports.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> execute() => repository.logout();
}
