import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/core/log/logger_provider.dart';
import 'package:repondo/features/item/data/repositories/firebase_item_repository.dart';
import 'package:repondo/features/item/domain/repositories/item_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_repository_provider.g.dart';

@riverpod
ItemRepository itemRepository(Ref ref) {
  return FirebaseItemRepository(logger: ref.read(loggerProvider));
}
