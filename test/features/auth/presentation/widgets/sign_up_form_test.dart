import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/presentation/widgets/keys/sign_up_form_keys.dart';
import 'package:repondo/features/auth/presentation/widgets/sign_up_form.dart';

void main() {
  late GlobalKey<FormState> formKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late bool submitted;

  setUp(() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    submitted = false;
  });

  Widget buildWidget(AsyncValue<UserAuth?> state) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SignUpForm(
            formKey: formKey,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            state: state,
            onSubmit: () {
              if (formKey.currentState?.validate() ?? false) {
                submitted = true;
              }
            },
          ),
        ),
      ),
    );
  }

  group('SignUpForm', () {
    testWidgets('Renderiza campos e botão corretamente', (tester) async {
      await tester.pumpWidget(buildWidget(const AsyncData(null)));

      expect(find.byKey(SignUpFormKeys.emailField), findsOneWidget);
      expect(find.byKey(SignUpFormKeys.passwordField), findsOneWidget);
      expect(find.byKey(SignUpFormKeys.confirmPasswordField), findsOneWidget);
      expect(find.byKey(SignUpFormKeys.submitButton), findsOneWidget);
    });

    testWidgets('Mostra erro ao submeter com email inválido', (tester) async {
      await tester.pumpWidget(buildWidget(const AsyncData(null)));

      await tester.enterText(find.byKey(SignUpFormKeys.emailField), 'email');
      await tester.enterText(
          find.byKey(SignUpFormKeys.passwordField), '12345a');
      await tester.enterText(
          find.byKey(SignUpFormKeys.confirmPasswordField), '12345a');

      await tester.tap(find.byKey(SignUpFormKeys.submitButton));
      await tester.pump();

      expect(find.textContaining('Email inválido'), findsOneWidget);
      expect(submitted, isFalse);
    });

    testWidgets('Mostra erro se senhas não coincidem', (tester) async {
      await tester.pumpWidget(buildWidget(const AsyncData(null)));

      await tester.enterText(
          find.byKey(SignUpFormKeys.emailField), 'teste@teste.com');
      await tester.enterText(
          find.byKey(SignUpFormKeys.passwordField), '12345a');
      await tester.enterText(
          find.byKey(SignUpFormKeys.confirmPasswordField), 'diferente1');

      await tester.tap(find.byKey(SignUpFormKeys.submitButton));
      await tester.pump();

      expect(find.textContaining('As senhas não coincidem'), findsExactly(1));
      expect(submitted, isFalse);
    });

    testWidgets('Não chama onSubmit se form for inválido', (tester) async {
      await tester.pumpWidget(buildWidget(const AsyncData(null)));

      await tester.enterText(find.byKey(SignUpFormKeys.emailField), '');

      await tester.tap(find.byKey(SignUpFormKeys.submitButton));
      await tester.pump();

      expect(submitted, isFalse);
    });

    testWidgets('Chama onSubmit quando form é válido', (tester) async {
      await tester.pumpWidget(buildWidget(const AsyncData(null)));

      await tester.enterText(
          find.byKey(SignUpFormKeys.emailField), 'teste@teste.com');
      await tester.enterText(
          find.byKey(SignUpFormKeys.passwordField), '12345a');
      await tester.enterText(
          find.byKey(SignUpFormKeys.confirmPasswordField), '12345a');

      await tester.tap(find.byKey(SignUpFormKeys.submitButton));
      await tester.pump();

      expect(submitted, isTrue);
    });

    testWidgets('Mostra loading quando estado é AsyncLoading', (tester) async {
      await tester.pumpWidget(buildWidget(const AsyncLoading()));

      expect(find.byKey(SignUpFormKeys.loadingIndicator), findsOneWidget);
      expect(find.byKey(SignUpFormKeys.submitButton), findsNothing);
    });

    testWidgets('Exibe mensagem de erro quando AsyncError', (tester) async {
      await tester.pumpWidget(buildWidget(
          AsyncError(Exception('Erro de teste'), StackTrace.empty)));

      expect(find.byKey(SignUpFormKeys.errorMessage), findsOneWidget);
    });
  });
}
