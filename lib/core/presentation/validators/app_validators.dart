class AppValidators {
  AppValidators._();

  /// Verifica se o campo foi preenchido.
  static String? validateField(String? value, {String fieldName = 'Campo'}) {
    final field = value?.trim();

    if (field == null || field.isEmpty) {
      return '$fieldName não pode ficar vazio';
    }

    return null;
  }
}
