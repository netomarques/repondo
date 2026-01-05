import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/get_current_email_notifier.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/sign_out_email_notifier.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/presentation/notifiers/fetch_despensa_notifier.dart';
import 'package:repondo/features/despensa/presentation/router/despensa_route_locations.dart';
import 'package:repondo/features/item/presentation/notifiers/fetch_despensa_items_notifier.dart';
import 'package:repondo/features/item/presentation/router/item_route_locations.dart';
import 'package:repondo/features/item/presentation/widgets/despensa_items_list.dart';

class HomePage extends ConsumerStatefulWidget {
  static HomePage builder(BuildContext context, GoRouterState state) =>
      const HomePage();

  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(fetchDespensaNotifierProvider.notifier)
          .fetchDespensa(despensaId: 'CIqqhHFZNMS9rpQ0uVu4');
      ref
          .read(fetchDespensaItemsNotifierProvider.notifier)
          .fetchItems(despensaId: 'CIqqhHFZNMS9rpQ0uVu4');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(getCurrentEmailNotifierProvider);
    final notifier = ref.read(signOutEmailNotifierProvider.notifier);
    final despensaAsync = ref.watch(fetchDespensaNotifierProvider);
    final itemsAsync = ref.watch(fetchDespensaItemsNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(userAsync, despensaAsync, notifier),
      body: userAsync.when(
        data: (user) => user != null
            ? despensaAsync.when(
                data: (despensa) => despensa != null
                    ? _successBuild(user, despensa)
                    : _errorBuild('Erro ao carregar despensa'),
                loading: () => _loadingBuild(),
                error: (e, _) => _errorBuild('Erro ao carregar despensa'),
              )
            : _errorBuild('Erro ao carregar usuário'),
        loading: () => _loadingBuild(),
        error: (e, _) => _errorBuild('Erro ao carregar usuário'),
      ),
    );
  }

  _errorBuild(String msg) => Center(child: Text(msg));

  _loadingBuild() {
    return Center(child: CircularProgressIndicator());
  }

  _successBuild(UserAuth user, Despensa despensa) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: const Text(
              'Bem-vindo ao Repondo!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (user.photoUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl!),
              radius: 40,
            ),
          const SizedBox(height: 12),
          if (user.name != null)
            Text(
              user.name!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          const SizedBox(height: 4),
          if (user.email != null)
            Text(
              user.email!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const Expanded(child: DespensaItemsList()),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(
    AsyncValue<UserAuth?> userAsync,
    AsyncValue<Despensa?> despensaAsync,
    SignOutEmailNotifier notifier,
  ) {
    if (!userAsync.hasValue || !despensaAsync.hasValue) return null;

    final despensa = despensaAsync.value;
    if (despensa == null) return null;

    return AppBar(
      title: Text('REPONDO - ${despensa.name}'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'criar-despensa':
                context.pushNamed(DespensaRouteLocations.despensaCreateName);
                break;
              case 'criar-item':
                context.pushNamed(ItemRouteLocations.itemCreateName);
                break;
              case 'sair':
                await notifier.signOut();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'criar-despensa',
              child: Text('Criar despensa'),
            ),
            const PopupMenuItem(
              value: 'criar-item',
              child: Text('Criar item'),
            ),
            const PopupMenuItem(
              value: 'sair',
              child: Text('Sair'),
            ),
          ],
        )
      ],
    );
  }
}
