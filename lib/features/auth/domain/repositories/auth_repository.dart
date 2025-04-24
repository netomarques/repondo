import '../entities/user_auth.dart';

abstract class AuthRepository {
  Future<UserAuth?> getCurrentUser();
  Stream<UserAuth?> get userStream;
  Future<UserAuth> signInAnonymously();
  Future<UserAuth> signInWithEmailAndPassword(String email, String password);
  Future<UserAuth> signInWithGoogle();
  Future<void> signOut();
}
