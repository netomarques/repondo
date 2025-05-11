import 'package:repondo/core/result/result.dart';

Future<Result<T, E>> runCatching<T, E>(
  Future<T> Function() action,
  E Function(Object error) onError,
) async {
  try {
    final result = await action();
    return Success(result);
  } catch (e) {
    return Failure(onError(e));
  }
}

Result<T, E> runCatchingSync<T, E>(
  T Function() action,
  E Function(Object error) onError,
) {
  try {
    final result = action();
    return Success(result);
  } catch (e) {
    return Failure(onError(e));
  }
}
