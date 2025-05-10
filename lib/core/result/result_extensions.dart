import 'result.dart';

extension ResultExtensions<T, E> on Result<T, E> {
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    return switch (this) {
      Success(:final value) => success(value),
      Failure(:final error) => failure(error),
    };
  }

  Result<U, E> map<U>(U Function(T data) transform) {
    return switch (this) {
      Success(:final value) => Success(transform(value)),
      Failure(:final error) => Failure(error),
    };
  }

  R fold<R>(R Function(E error) onFailure, R Function(T data) onSuccess) {
    return this is Success<T, E>
        ? onSuccess((this as Success<T, E>).value)
        : onFailure((this as Failure<T, E>).error);
  }

  void onSuccess(void Function(T data) callback) {
    if (this is Success<T, E>) {
      callback((this as Success<T, E>).value);
    }
  }

  void onFailure(void Function(E error) callback) {
    if (this is Failure<T, E>) {
      callback((this as Failure<T, E>).error);
    }
  }
}
