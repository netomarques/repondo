import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/get_current_email_notifier.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/sign_out_email_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(getCurrentEmailNotifierProvider);
    final notifier = ref.read(signOutEmailNotifierProvider.notifier);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Erro ao carregar usuário'))),
      data: (user) => user == null
          ? Scaffold(body: Center(child: Text('Erro ao carregar usuário')))
          : Scaffold(
              appBar: AppBar(
                title: const Text('Repondo'),
                actions: [
                  IconButton(
                    onPressed: () async => await notifier.signOut(),
                    icon: const Icon(Icons.logout),
                    tooltip: 'Sair',
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                  ],
                ),
              ),
            ),
    );
  }
}
