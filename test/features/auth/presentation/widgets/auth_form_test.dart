import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/constants/firebase_auth_error_codes.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/invalid_credentials_exception.dart';
import 'package:repondo/features/auth/presentation/widgets/auth_form.dart';

void main() {
  testWidgets('exibe mensagem de erro quando credenciais são inválidas',
      (WidgetTester tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AuthForm(
              formKey: formKey,
              emailController: emailController,
              passwordController: passwordController,
              state: AsyncValue<UserAuth?>.error(
                  InvalidCredentialsException(
                      code: FirebaseAuthErrorCodes.wrongPassword),
                  StackTrace.empty),
              onSubmit: () {},
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.textContaining(AuthErrorMessages.invalidCredentials),
        findsOneWidget);
  });
}
