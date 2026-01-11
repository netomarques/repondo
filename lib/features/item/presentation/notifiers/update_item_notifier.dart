import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/item/application/facades/item_facade.dart';
import 'package:repondo/features/item/application/providers/facades/item_facade_provider.dart';
import 'package:repondo/features/item/domain/params/update_item_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_item_notifier.g.dart';

@riverpod
class UpdateItemNotifier extends _$UpdateItemNotifier {
  ItemFacade get _itemFacade => ref.read(itemFacadeProvider);

  @override
  Future<void> build() async {}

  Future<void> updateItem({
    required UpdateItemParams params,
    required String despensaId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result =
          await _itemFacade.updateItem(params: params, despensaId: despensaId);
      return result.fold(
        (error) => throw error,
        (_) => null,
      );
    });
  }
}
