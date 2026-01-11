import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/core/presentation/animations/bottom_sheet_page.dart';
import 'package:repondo/core/presentation/widgets/async_value_listener.dart';
import 'package:repondo/core/presentation/widgets/button_form.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/exceptions/item_exception.dart';
import 'package:repondo/features/item/domain/params/update_item_params.dart';
import 'package:repondo/features/item/presentation/notifiers/fetch_despensa_items_notifier.dart';
import 'package:repondo/features/item/presentation/notifiers/update_item_notifier.dart';
import 'package:repondo/features/item/presentation/widgets/update_item_form.dart';

class UpdateItemPage extends ConsumerStatefulWidget {
  final Item item;

  const UpdateItemPage({
    super.key,
    required this.item,
  });

  static CustomTransitionPage pageBuilder(
    BuildContext context,
    GoRouterState state,
    Item item,
  ) =>
      bottomSheetPage(
        key: state.pageKey,
        child: UpdateItemPage(item: item),
      );

  @override
  ConsumerState<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends ConsumerState<UpdateItemPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _categoryController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _nameController = TextEditingController(text: item.name);
    _quantityController = TextEditingController(text: item.quantity.toString());
    _categoryController = TextEditingController(text: item.category);
    _unitController = TextEditingController(text: item.unit);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateItemNotifierProvider);

    return AsyncValueListener<void, ItemException>(
      provider: updateItemNotifierProvider,
      messageSuccess: 'Item atualizado com sucesso!',
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar item',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Atualize apenas os campos desejados.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      UpdateItemForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        quantityController: _quantityController,
                        categoryController: _categoryController,
                        unitController: _unitController,
                        button: ButtonForm(
                          onSubmit: _submit,
                          textAction: 'SALVAR ALTERAÇÕES',
                          isLoading: state.isLoading,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final item = widget.item;

    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text.trim());
    final category = _categoryController.text.trim();
    final unit = _unitController.text.trim();

    final params = UpdateItemParams(
      itemId: item.id,
      name: name != item.name ? name : null,
      quantity: quantity != item.quantity ? quantity : null,
      category: category != item.category ? category : null,
      unit: unit != item.unit ? unit : null,
    );

    await ref.read(updateItemNotifierProvider.notifier).updateItem(
          params: params,
          despensaId: 'CIqqhHFZNMS9rpQ0uVu4',
        );

    ref
        .read(fetchDespensaItemsNotifierProvider.notifier)
        .fetchItems(despensaId: 'CIqqhHFZNMS9rpQ0uVu4');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}
