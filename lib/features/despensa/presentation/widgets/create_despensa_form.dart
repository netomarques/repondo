import 'package:flutter/material.dart';
import 'package:repondo/core/presentation/exports.dart';

class CreateDespensaForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final Widget button;

  const CreateDespensaForm(
      {super.key,
      required this.formKey,
      required this.nameController,
      required this.button});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: nameController,
            labelText: 'Nome da despensa',
            textInputType: TextInputType.text,
            validator: AppValidators.validateField,
          ),
          const SizedBox(height: 24),
          button,
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
