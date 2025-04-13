import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Stream<User?> get userStream;
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> signInWithGoogle();
  Future<void> signOut();
}
