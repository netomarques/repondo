import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth.freezed.dart';

@freezed
abstract class UserAuth with _$UserAuth {
  factory UserAuth({
    required String id,
    String? name,
    String? email,
    String? photoUrl,
    @Default(false) bool isAnonymous,
  }) = _UserAuth;
}
