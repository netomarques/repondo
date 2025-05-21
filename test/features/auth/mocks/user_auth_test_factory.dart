import 'package:repondo/features/auth/domain/entities/user_auth.dart';

final class UserAuthTestFactory {
  static UserAuth create({
    String? email,
    String? name,
    String? photoUrl,
  }) =>
      UserAuth(
        id: 'userId',
        name: name ?? 'User Name',
        email: email ?? 'email@example.com',
        photoUrl: photoUrl ?? 'https://example.com/photo.jpg',
      );
}
