import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/despensa/application/facades/despensa_facade.dart';
import 'package:repondo/features/despensa/application/providers/facades/despensa_facade_provider.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_despensa_notifier.g.dart';

@riverpod
class FetchDespensaNotifier extends _$FetchDespensaNotifier {
  DespensaFacade get _despensaFacade => ref.read(despensaFacadeProvider);

  @override
  Future<Despensa?> build() async => null;

  Future<void> fetchDespensa({required String despensaId}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result =
          await _despensaFacade.fetchDespensa(despensaId: despensaId);
      return result.fold(
        (error) => throw error,
        (despensa) => despensa,
      );
    });
  }
}
