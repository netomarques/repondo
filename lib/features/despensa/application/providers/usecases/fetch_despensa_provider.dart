import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/despensa/application/providers/repositories/despensa_repository_provider.dart';
import 'package:repondo/features/despensa/application/usecases/fetch_despensa_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_despensa_provider.g.dart';

@riverpod
FetchDespensaUseCase fetchDespensaUseCase(Ref ref) {
  final despensaRepository = ref.read(despensaRepositoryProvider);
  return FetchDespensaUseCase(despensaRepository);
}
