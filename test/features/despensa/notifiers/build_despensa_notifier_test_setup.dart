import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/despensa/application/providers/facades/despensa_facade_provider.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';

import '../../../core/notifier_test_context.dart';
import '../mocks/despensa_mocks.mocks.dart';

Future<NotifierTestContext<T, NotifierT>> buildDespensaNotifierTestContext<T,
    NotifierT extends AutoDisposeAsyncNotifier<T>>({
  required MockDespensaFacade facade,
  required AutoDisposeAsyncNotifierProvider<NotifierT, T> notifierProvider,
  required Result<T, DespensaException> dummyResult,
}) async {
  // Configuração do valor dummy para evitar MissingDummyValueError
  provideDummy<Result<T, DespensaException>>(dummyResult);

  // Cria um container com a dependência substituída pelo mock
  final container = ProviderContainer(overrides: [
    despensaFacadeProvider.overrideWithValue(facade),
  ]);

  // Garante que o container será fechado após os testes
  addTearDown(container.dispose);

  // Aguarda a inicialização completa do provider (necessário para garantir que está pronto para uso, build + estado inicial)
  await container.read(notifierProvider.future);
  // Limpa interações anteriores com o mock inicializado com build para evitar contagens erradas
  clearInteractions(facade);

  // Obtém o Notifier responsável por chamar o método a ser testado
  final notifier = container.read(notifierProvider.notifier);
  // Lista para armazenar os estados emitidos pelo provider durante a chamada
  final states = <AsyncValue<T>>[];
  // Observa o provider e registra cada mudança de estado
  final subscription = container.listen<AsyncValue<T>>(
    notifierProvider,
    (_, state) => states.add(state),
  );
  // Garante que o listener será cancelado após o teste
  addTearDown(subscription.close);

  // Retorna o notifier, states
  // para que possam ser utilizados nos testes
  return (notifier: notifier, states: states);
}
