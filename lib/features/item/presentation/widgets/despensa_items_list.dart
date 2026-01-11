import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/presentation/notifiers/delete_item_notifier.dart';
import 'package:repondo/features/item/presentation/notifiers/fetch_despensa_items_notifier.dart';
import 'package:repondo/features/item/presentation/router/item_route_locations.dart';

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

class _ItemTile extends ConsumerWidget {
  final Item item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(
        'Quantidade: ${item.quantity} ${item.unit}',
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'edit') {
            context.pushNamed(
              ItemRouteLocations.itemUpdateName,
              extra: item,
            );
          }

          if (value == 'delete') {
            await _confirmAndDelete(context, ref);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: 'edit',
            child: Text('Editar'),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir item'),
        content: const Text('Deseja realmente excluir este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(deleteItemNotifierProvider.notifier).deleteItem(
          despensaId: 'CIqqhHFZNMS9rpQ0uVu4', // ou provider global
          itemId: item.id,
        );

    // Atualiza lista após delete
    ref
        .read(fetchDespensaItemsNotifierProvider.notifier)
        .fetchItems(despensaId: 'CIqqhHFZNMS9rpQ0uVu4');
  }
}
