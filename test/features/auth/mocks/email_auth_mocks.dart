import 'package:mockito/annotations.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/domain/services/auth_service.dart';

@GenerateMocks([
  EmailAuthFacade,
  AuthService,
])
void main() {}
