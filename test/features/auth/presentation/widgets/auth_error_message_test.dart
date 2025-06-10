import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/features/auth/domain/constants/firebase_auth_error_codes.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/exports.dart';
import 'package:repondo/features/auth/presentation/widgets/auth_error_message.dart';

void main() {
  // Grupo principal de testes para o widget AuthErrorMessage
  group('AuthErrorMessage', () {
    // Função auxiliar para montar o widget com o ProviderScope e MaterialApp,
    // necessário para rodar o widget no ambiente de teste
    Widget buildTestWidget(AsyncValue<UserAuth?> state) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: AuthErrorMessage(state: state)),
        ),
      );
    }

    group('casos com erro', () {
      testWidgets('exibe mensagem de erro quando ocorre AuthException',
          (tester) async {
        // Criando uma instância de erro específico que herda AuthException
        final AuthException error = InvalidCredentialsException(
            code: FirebaseAuthErrorCodes.wrongPassword);

        // Monta o widget com o estado de erro
        await tester.pumpWidget(buildTestWidget(
          AsyncValue.error(error, StackTrace.empty),
        ));

        // Verifica se o texto da mensagem de erro da exceção está presente na tela
        expect(find.textContaining(error.message), findsOneWidget);
      });

      testWidgets(
          'exibe mensagem de erro desconhecido se não for AuthException',
          (tester) async {
        // Passa um erro genérico para simular exceção desconhecida
        await tester.pumpWidget(buildTestWidget(
          AsyncValue.error(Exception('Erro'), StackTrace.empty),
        ));

        expect(find.textContaining('Erro desconhecido'), findsOneWidget);
      });
    });

    group('casos quando não há erro', () {
      testWidgets(
          'não exibe mensagem gerada por AuthException quando não houver erro',
          (tester) async {
        final AuthException error = InvalidCredentialsException(
            code: FirebaseAuthErrorCodes.wrongPassword);

        // Passa um estado com dado válido (sem erro)
        await tester.pumpWidget(buildTestWidget(
          AsyncValue.data(null),
        ));

        // Verifica se nenhum texto contenha message de erro está na tela
        expect(find.textContaining(error.message), findsNothing);
      });

      testWidgets('não exibe mensagem quando não houver erro', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          AsyncValue.data(null),
        ));

        // Verifica se nenhum texto contenha 'Erro:' está na tela
        expect(find.textContaining('Erro desconhecido'), findsNothing);
      });
    });
  });
}
