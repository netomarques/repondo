import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';

/// Tupla nomeada com o Notifier testado e a lista de estados emitidos
typedef NotifierTestContext<T, NotifierT extends AutoDisposeAsyncNotifier<T>>
    = ({
  NotifierT notifier,
  List<AsyncValue<T>> states,
});

Future<NotifierTestContext<T, NotifierT>>
    buildNotifierTestContext<T, NotifierT extends AutoDisposeAsyncNotifier<T>>({
  required MockEmailAuthFacade facade,
  required AutoDisposeAsyncNotifierProvider<NotifierT, T> notifierProvider,
  required Result<T, AuthException> dummyResult,
}) async {
  // Configuração do valor dummy para evitar MissingDummyValueError
  provideDummy<Result<T, AuthException>>(dummyResult);

  // Cria um container com a dependência substituída pelo mock
  final container = ProviderContainer(overrides: [
    emailAuthFacadeProvider.overrideWithValue(facade),
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
