import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/item/application/facades/item_facade.dart';
import 'package:repondo/features/item/application/providers/usecases/exports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_facade_provider.g.dart';

@riverpod
ItemFacade itemFacade(Ref ref) {
  final createItemUseCase = ref.read(createItemUseCaseProvider);
  final fetchDespensaItemsUseCase = ref.read(fetchDespensaItemsUseCaseProvider);

  return ItemFacade(
    createItemUseCase: createItemUseCase,
    fetchDespensaItemsUseCase: fetchDespensaItemsUseCase,
  );
}
