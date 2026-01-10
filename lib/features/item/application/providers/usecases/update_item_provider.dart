import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/item/application/providers/repositories/item_repository_provider.dart';
import 'package:repondo/features/item/application/usecases/update_item_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_item_provider.g.dart';

@riverpod
UpdateItemUseCase updateItemUseCase(Ref ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UpdateItemUseCase(itemRepository);
}
