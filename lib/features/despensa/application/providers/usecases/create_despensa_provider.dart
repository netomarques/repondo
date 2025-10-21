import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/despensa/application/providers/repositories/despensa_repository_provider.dart';
import 'package:repondo/features/despensa/application/usecases/create_despensa_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_despensa_provider.g.dart';

@riverpod
CreateDespensaUseCase createDespensaUseCase(Ref ref) {
  final despensaRepository = ref.read(despensaRepositoryProvider);
  return CreateDespensaUseCase(despensaRepository);
}
