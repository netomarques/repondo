import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/item/application/facades/item_facade.dart';
import 'package:repondo/features/item/application/providers/facades/item_facade_provider.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_despensa_items_notifier.g.dart';

@riverpod
class FetchDespensaItemsNotifier extends _$FetchDespensaItemsNotifier {
  ItemFacade get _itemFacade => ref.read(itemFacadeProvider);

  @override
  Future<List<Item>> build() async => <Item>[];

  Future<void> fetchItems({required String despensaId}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result =
          await _itemFacade.fetchDespensaItems(despensaId: despensaId);
      return result.fold((error) => throw error, (items) => items);
    });
  }
}
