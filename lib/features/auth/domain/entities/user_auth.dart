import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth.freezed.dart';
part 'user_auth.g.dart';

@freezed
abstract class UserAuth with _$UserAuth {
  factory UserAuth({
    required String id,
    String? name,
    String? email,
    String? photoUrl,
    @Default(false) bool isAnonymous,
  }) = _UserAuth;

  factory UserAuth.fromJson(Map<String, dynamic> json) =>
      _$UserAuthFromJson(json);
}
