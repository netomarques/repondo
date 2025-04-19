import 'package:repondo/features/auth/domain/entities/user.dart';

abstract class EmailAuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp();
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Stream<User?> get userStream;
}
