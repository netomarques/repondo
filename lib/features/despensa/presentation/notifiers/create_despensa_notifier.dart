import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/despensa/application/facades/despensa_facade.dart';
import 'package:repondo/features/despensa/application/providers/facades/despensa_facade_provider.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_despensa_notifier.g.dart';

@riverpod
class CreateDespensaNotifier extends _$CreateDespensaNotifier {
  DespensaFacade get _despensaFacade => ref.read(despensaFacadeProvider);

  @override
  Future<Despensa?> build() async => null;

  Future<void> createDespensa(CreateDespensaParams params) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _despensaFacade.createDespensa(params: params);
      return result.fold(
        (error) => throw error,
        (despensa) => despensa,
      );
    });
  }
}
