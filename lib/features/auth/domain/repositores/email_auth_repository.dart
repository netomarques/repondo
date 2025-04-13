import 'package:repondo/features/auth/domain/entities/user.dart';

abstract class EmailAuthRepository {
  Future<User> signIn();
  Future<User> signUp();
  Future<void> signOut();
  Future<User> getCurrentUser();
}
