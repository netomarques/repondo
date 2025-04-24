import 'package:repondo/features/auth/domain/entities/user_auth.dart';

abstract class EmailAuthRepository {
  Future<UserAuth> signIn(String email, String password);
  Future<UserAuth> signUp();
  Future<void> signOut();
  Future<UserAuth?> getCurrentUser();
  Stream<UserAuth?> get userStream;
}
