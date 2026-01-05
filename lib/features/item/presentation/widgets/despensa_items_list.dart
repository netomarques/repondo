import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/presentation/notifiers/fetch_despensa_items_notifier.dart';

class DespensaItemsList extends ConsumerWidget {
  const DespensaItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(fetchDespensaItemsNotifierProvider);

    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text('Nenhum item na despensa'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            return _ItemTile(item: item);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => const Center(
        child: Text('Erro ao carregar itens da despensa'),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final Item item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(
        'Quantidade: ${item.quantity} ${item.unit}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Futuro: navegar para detalhe do item
      },
    );
  }
}
