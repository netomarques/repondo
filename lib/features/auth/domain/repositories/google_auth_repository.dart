import 'package:repondo/features/auth/domain/entities/user_auth.dart';

abstract class GoogleAuthRepository {
  Future<UserAuth> signIn();
  Future<void> signOut();
  Future<UserAuth> getCurrentUser();
  Stream<UserAuth> get userStream;
}
