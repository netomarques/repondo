import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/core/presentation/animations/exports.dart';
import 'package:repondo/core/presentation/widgets/exports.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/get_current_email_notifier.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:repondo/features/despensa/presentation/notifiers/create_despensa_notifier.dart';
import 'package:repondo/features/despensa/presentation/widgets/create_despensa_form.dart';

class CreateDespensaPage extends ConsumerStatefulWidget {
  static CustomTransitionPage pageBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      bottomSheetPage(key: state.pageKey, child: const CreateDespensaPage());

  const CreateDespensaPage({super.key});

  @override
  ConsumerState<CreateDespensaPage> createState() => _CreateDespensaPageState();
}

class _CreateDespensaPageState extends ConsumerState<CreateDespensaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createDespensaNotifierProvider);

    return AsyncValueListener<Despensa?, DespensaException>(
      provider: createDespensaNotifierProvider,
      messageSuccess: 'Despensa criada com sucesso!',
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
                        "Criar nova despensa",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Preencha as informações abaixo para criar sua despensa.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      CreateDespensaForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        button: ButtonForm(
                          onSubmit: _submit,
                          textAction: 'CRIAR DESPENSA',
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
    final user = ref.read(getCurrentEmailNotifierProvider).value;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao criar despensa: Usuário é null'),
      ));
      return;
    }

    final params = CreateDespensaParams(
      name: name,
      adminIds: [user.id],
      memberIds: [user.id],
    );

    await ref
        .read(createDespensaNotifierProvider.notifier)
        .createDespensa(params);
  }

  @override
  dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
