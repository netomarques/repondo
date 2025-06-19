/// Remove espaços no início e fim antes de validar email.
/// Rejeita emails com espaços internos.
String? validateEmail(String? value) {
  final email = value?.trim();

  if (email == null || email.isEmpty) return 'Informe o email';

  if (email.contains(' ')) return 'Email não pode conter espaços';

  const pattern = r'^[^@]+@[^@]+\.[^@]+$';
  final regex = RegExp(pattern);

  if (!regex.hasMatch(email)) return 'Email inválido';

  return null;
}

String? validatePassword(String? value) {
  final password = value?.trim();

  if (password == null || password.isEmpty) {
    return 'Informe a senha';
  }

  if (password.contains(' ')) {
    return 'Senha não pode conter espaços';
  }

  if (password.length < 6) {
    return 'Senha deve ter pelo menos 6 caracteres';
  }

  final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
  final hasNumber = RegExp(r'\d').hasMatch(password);

  if (!hasLetter) {
    return 'Senha deve conter pelo menos uma letra';
  }

  if (!hasNumber) {
    return 'Senha deve conter pelo menos um número';
  }

  return null;
}

String? validatePasswordConfirmation(String? value, String originalPassword) {
  if (value == null || value.isEmpty) return 'Confirme a senha';
  if (value != originalPassword) return 'As senhas não coincidem';
  return null;
}
