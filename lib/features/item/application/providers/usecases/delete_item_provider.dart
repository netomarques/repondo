import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/item/application/providers/repositories/item_repository_provider.dart';
import 'package:repondo/features/item/application/usecases/delete_item_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_item_provider.g.dart';

@riverpod
DeleteItemUseCase deleteItemUseCase(Ref ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return DeleteItemUseCase(itemRepository);
}
