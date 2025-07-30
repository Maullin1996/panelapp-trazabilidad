import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class AppFormTextFild extends StatelessWidget {
  final String name;
  final String label;
  final String? initialValue;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? valueTransformer;

  const AppFormTextFild({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.valueTransformer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smallLarge,
        vertical: AppSpacing.xSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            color: Colors.black.withAlpha(50),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.secondaryDarkPanela, width: 2),
      ),
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        initialValue: initialValue,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        valueTransformer: valueTransformer,
      ),
    );
  }
}
