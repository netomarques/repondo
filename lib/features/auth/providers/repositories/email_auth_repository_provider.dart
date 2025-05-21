import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/data/repositories/firebase_email_auth_repository.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_auth_repository_provider.g.dart';

/// Provider para o repositório de autenticação com email (implementação Firebase).
@riverpod
EmailAuthRepository emailAuthRepository(Ref ref) {
  return FirebaseEmailAuthRepository();
}
