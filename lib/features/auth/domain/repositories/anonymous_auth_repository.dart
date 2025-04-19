import 'package:repondo/features/auth/domain/entities/user.dart';

abstract class AnonymousAuthRepository {
  Future<User> signIn();
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Stream<User?> get userStream;
}
