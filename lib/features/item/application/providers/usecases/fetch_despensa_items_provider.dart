import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/item/application/providers/repositories/item_repository_provider.dart';
import 'package:repondo/features/item/application/usecases/fetch_despensa_items_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_despensa_items_provider.g.dart';

@riverpod
FetchDespensaItemsUseCase fetchDespensaItemsUseCase(Ref ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return FetchDespensaItemsUseCase(itemRepository);
}
