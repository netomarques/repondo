import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/core/exceptions/app_exception.dart';

class AsyncValueListener<T, E extends AppException> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<T>> provider;
  final String messageSuccess;
  final Widget _child;

  const AsyncValueListener({
    super.key,
    required this.provider,
    required this.messageSuccess,
    Widget? child,
  }) : _child = child ?? const SizedBox.shrink();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<T>>(
      provider,
      (prev, next) {
        next.whenOrNull(
          error: (err, _) {
            final String messageError;
            if (err is! E) {
              messageError = 'Erro desconhecido';
            } else {
              messageError = err.message;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  messageError,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          },
          data: (_) {
            if (prev is AsyncLoading<T> && next.value != null) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(messageSuccess)),
              );
            }
          },
        );
      },
    );

    return _child;
  }
}
