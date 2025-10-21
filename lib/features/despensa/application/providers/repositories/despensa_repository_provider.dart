import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/core/log/logger_provider.dart';
import 'package:repondo/features/despensa/data/repositories/firebase_despensa_repository.dart';
import 'package:repondo/features/despensa/domain/repositories/despensa_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'despensa_repository_provider.g.dart';

@riverpod
DespensaRepository despensaRepository(Ref ref) {
  return FirebaseDespensaRepository(logger: ref.read(loggerProvider));
}
