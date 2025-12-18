import 'package:flutter/material.dart';
import 'package:repondo/core/presentation/validators/app_validators.dart';
import 'package:repondo/core/presentation/widgets/app_text_form_field.dart';

class CreateItemForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController categoryController;
  final TextEditingController unitController;
  final Widget button;

  const CreateItemForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.quantityController,
    required this.categoryController,
    required this.unitController,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: nameController,
            labelText: 'Nome do item',
            textInputType: TextInputType.text,
            validator: AppValidators.validateField,
          ),
          const SizedBox(height: 8),
          AppTextFormField(
            controller: quantityController,
            labelText: 'Quantidade',
            textInputType: TextInputType.text,
            validator: AppValidators.validateField,
          ),
          const SizedBox(height: 8),
          AppTextFormField(
            controller: categoryController,
            labelText: 'Categoria',
            textInputType: TextInputType.text,
            validator: AppValidators.validateField,
          ),
          const SizedBox(height: 8),
          AppTextFormField(
            controller: unitController,
            labelText: 'Unidade',
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
