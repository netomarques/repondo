import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/features/auth/presentation/validators/auth_validators.dart';

void main() {
  group('validateEmail', () {
    test('retorna erro se email for nulo ou vazio', () {
      expect(validateEmail(null), 'Informe o email');
      expect(validateEmail(''), 'Informe o email');
      expect(validateEmail('   '), 'Informe o email');
    });

    test('retornar erro se email tiver espaço entre os caracteres', () {
      expect(
          validateEmail('usua rio@email.com'), 'Email não pode conter espaços');
      expect(validateEmail('usuario@email.com '), isNull);
      expect(validateEmail(' usuario@email.com'), isNull);
    });

    test('retorna erro se email for inválido', () {
      expect(validateEmail('usuario'), 'Email inválido');
      expect(validateEmail('usuario@'), 'Email inválido');
      expect(validateEmail('usuario@.com'), 'Email inválido');
      expect(validateEmail('usuario@email'), 'Email inválido');
      expect(validateEmail('usuario@email.'), 'Email inválido');
      expect(validateEmail('@email.com'), 'Email inválido');
    });

    test('retorna null se email for válido', () {
      expect(validateEmail('usuario@email.com'), null);
      expect(validateEmail('user.name@dominio.co'), null);
      expect(validateEmail('a@b.com'), null);
    });
  });

  group('validatePassword', () {
    test('retorna erro se senha for nula ou vazia', () {
      expect(validatePassword(null), 'Informe a senha');
      expect(validatePassword(''), 'Informe a senha');
      expect(validatePassword('   '), 'Informe a senha');
    });

    test('retornar erro se senha tiver espaço entre os caracteres', () {
      expect(validatePassword('A1b 2c3'), 'Senha não pode conter espaços');
    });

    test('retorna erro se senha tiver menos de 6 caracteres', () {
      expect(
          validatePassword('12345'), 'Senha deve ter pelo menos 6 caracteres');
    });

    test('retorna erro se não tiver letras', () {
      expect(
          validatePassword('123456'), 'Senha deve conter pelo menos uma letra');
      expect(validatePassword('1234567890'),
          'Senha deve conter pelo menos uma letra');
    });

    test('retorna erro se não tiver números', () {
      expect(
        validatePassword('abcdef'),
        'Senha deve conter pelo menos um número',
      );
      expect(validatePassword('ABCdefgh'),
          'Senha deve conter pelo menos um número');
    });

    test('retorna null se senha for válida', () {
      expect(validatePassword('abc123'), null);
      expect(validatePassword('senha2024'), null);
      expect(validatePassword('A1b2c3'), null);
    });
  });

  group('validatePasswordConfirmation', () {
    test('retorna erro se confirmação for nula ou vazia', () {
      expect(validatePasswordConfirmation(null, '123456'), 'Confirme a senha');
      expect(validatePasswordConfirmation('', '123456'), 'Confirme a senha');
    });

    test('retorna erro se senhas não coincidirem', () {
      expect(validatePasswordConfirmation('123457', '123456'),
          'As senhas não coincidem');
    });

    test('retorna null se as senhas coincidirem', () {
      expect(validatePasswordConfirmation('123456', '123456'), null);
    });
  });
}
