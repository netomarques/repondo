import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/item/application/facades/item_facade.dart';
import 'package:repondo/features/item/application/providers/facades/item_facade_provider.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/params/create_item_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_item_notifier.g.dart';

@riverpod
class CreateItemNotifier extends _$CreateItemNotifier {
  ItemFacade get _itemFacade => ref.read(itemFacadeProvider);

  @override
  Future<Item?> build() async => null;

  Future<void> createItem(CreateItemParams params, String despensaId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result =
          await _itemFacade.createItem(params: params, despensaId: despensaId);
      return result.fold(
        (error) => throw error,
        (item) => item,
      );
    });
  }
}
