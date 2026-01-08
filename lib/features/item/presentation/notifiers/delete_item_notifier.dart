import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/item/application/facades/item_facade.dart';
import 'package:repondo/features/item/application/providers/facades/item_facade_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_item_notifier.g.dart';

@riverpod
class DeleteItemNotifier extends _$DeleteItemNotifier {
  ItemFacade get _itemFacade => ref.read(itemFacadeProvider);

  @override
  Future<void> build() async {}

  Future<void> deleteItem({
    required String despensaId,
    required String itemId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result =
          await _itemFacade.deleteItem(itemId: itemId, despensaId: despensaId);
      return result.fold(
        (error) => throw error,
        (_) => null,
      );
    });
  }
}
