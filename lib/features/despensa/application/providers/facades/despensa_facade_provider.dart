import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/despensa/application/facades/despensa_facade.dart';
import 'package:repondo/features/despensa/application/providers/usecases/create_despensa_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'despensa_facade_provider.g.dart';

@riverpod
DespensaFacade despensaFacade(Ref ref) {
  final createDespensaUseCase = ref.read(createDespensaUseCaseProvider);

  return DespensaFacade(
    createDespensaUseCase: createDespensaUseCase,
  );
}
