import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/providers/facades/email_auth_facade_provider.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier.dart';

import '../../../mocks/email_auth_mocks.mocks.dart';
import '../../../mocks/user_auth_test_factory.dart';

Future<(EmailAuthNotifier notifier, List<AsyncValue<UserAuth?>> states)>
    buildEmailAuthNotifierTestContext(
  MockEmailAuthFacade facade,
) async {
  // Criação de um usuário de teste
  final expectedUser = UserAuthTestFactory.create();
  final result = Success<UserAuth?, AuthException>(expectedUser);

  // Configuração do valor dummy para evitar MissingDummyValueError
  provideDummy<Result<UserAuth?, AuthException>>(result);

  // Configura o mock para retornar sucesso com usuário
  when(facade.getCurrentUser()).thenAnswer((_) async => result);

  // Cria um container com a dependência substituída pelo mock
  final container = ProviderContainer(overrides: [
    emailAuthFacadeProvider.overrideWithValue(facade),
  ]);

  // Garante que o container será fechado após os testes
  addTearDown(container.dispose);

  // Aguarda a inicialização completa do provider (necessário para garantir que está pronto para uso, build + estado inicial)
  await container.read(emailAuthNotifierProvider.future);
  // Limpa interações anteriores com o mock inicializado com build para evitar contagens erradas
  clearInteractions(facade);

  // Obtém o Notifier responsável por chamar o método a ser testado
  final notifier = container.read(emailAuthNotifierProvider.notifier);
  // Lista para armazenar os estados emitidos pelo provider durante a chamada
  final states = <AsyncValue<UserAuth?>>[];
  // Observa o provider e registra cada mudança de estado
  final subscription = container.listen<AsyncValue<UserAuth?>>(
    emailAuthNotifierProvider,
    (_, state) => states.add(state),
  );
  // Garante que o listener será cancelado após o teste
  addTearDown(subscription.close);

  // Retorna o notifier, states
  // para que possam ser utilizados nos testes
  return (notifier, states);
}
