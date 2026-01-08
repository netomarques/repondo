import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/core/presentation/animations/bottom_sheet_page.dart';
import 'package:repondo/core/presentation/widgets/async_value_listener.dart';
import 'package:repondo/core/presentation/widgets/button_form.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/get_current_email_notifier.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/domain/exceptions/item_exception.dart';
import 'package:repondo/features/item/domain/params/create_item_params.dart';
import 'package:repondo/features/item/presentation/notifiers/create_item_notifier.dart';
import 'package:repondo/features/item/presentation/notifiers/fetch_despensa_items_notifier.dart';
import 'package:repondo/features/item/presentation/widgets/create_item_form.dart';

class CreateItemPage extends ConsumerStatefulWidget {
  static CustomTransitionPage pageBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      bottomSheetPage(child: const CreateItemPage(), key: state.pageKey);

  const CreateItemPage({super.key});

  @override
  ConsumerState<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends ConsumerState<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createItemNotifierProvider);

    return AsyncValueListener<Item?, ItemException>(
      provider: createItemNotifierProvider,
      messageSuccess: 'Item criado com sucesso!',
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
                padding: EdgeInsets.all(24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Criar novo item",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Preencha as informações abaixo para criar um item.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      CreateItemForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        quantityController: _quantityController,
                        categoryController: _categoryController,
                        unitController: _unitController,
                        button: ButtonForm(
                          onSubmit: _submit,
                          textAction: 'CRIAR ITEM',
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

    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final category = _categoryController.text.trim();
    final unit = _unitController.text.trim();
    final user = ref.read(getCurrentEmailNotifierProvider).value;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao criar item: Usuário é null'),
      ));
      return;
    }

    final addedBy = user.name!;
    final params = CreateItemParams(
      name: name,
      quantity: quantity,
      category: category,
      unit: unit,
      addedBy: addedBy,
    );

    await ref
        .read(createItemNotifierProvider.notifier)
        .createItem(params, 'CIqqhHFZNMS9rpQ0uVu4');

    ref
        .read(fetchDespensaItemsNotifierProvider.notifier)
        .fetchItems(despensaId: 'CIqqhHFZNMS9rpQ0uVu4');
  }

  @override
  dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}
