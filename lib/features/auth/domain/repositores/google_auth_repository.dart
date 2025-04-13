import 'package:repondo/features/auth/domain/entities/user.dart';

abstract class GoogleAuthRepository {
  Future<User> signIn();
  Future<void> signOut();
  Future<User> getCurrentUser();
}
