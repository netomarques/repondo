/// Representa o resultado de uma operação que pode retornar sucesso ou falha.
sealed class Result<T, E> {
  const Result();

  /// Retorna `true` se for um sucesso.
  bool get isSuccess => this is Success<T, E>;

  /// Retorna `true` se for uma falha.
  bool get isFailure => this is Failure<T, E>;

  /// Retorna o valor do sucesso, ou `null` se for falha.
  T? get data => this is Success<T, E> ? (this as Success<T, E>).value : null;

  /// Retorna o erro da falha, ou `null` se for sucesso.
  E? get error => this is Failure<T, E> ? (this as Failure<T, E>).error : null;
}

/// Representa o sucesso de uma operação.
final class Success<T, E> extends Result<T, E> {
  final T value;

  const Success(this.value);
}

/// Representa a falha de uma operação.
final class Failure<T, E> extends Result<T, E> {
  @override
  final E error;

  const Failure(this.error);
}
