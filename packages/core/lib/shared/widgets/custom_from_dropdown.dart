import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../utils/tokens.dart';

class CustomFromDropdown<T> extends StatelessWidget {
  final String name;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final ValueChanged<T?>? onChanged;

  const CustomFromDropdown({
    super.key,
    required this.name,
    required this.items,
    this.validator,
    this.onChanged,
  });

  static const BorderRadius _borderRadius = BorderRadius.all(
    Radius.circular(AppRadius.medium),
  );

  static const InputDecoration _decoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
    enabledBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: AppColors.secondaryDarkPanela, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: AppColors.primaryPanelaBrown, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    return FormBuilderDropdown<T>(
      name: name,
      items: items,
      validator: validator,
      onChanged: onChanged,
      menuWidth: width > 600 ? 320 : width * 0.95,
      borderRadius: _borderRadius,
      dropdownColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.xSmall,
      ),
      decoration: _decoration,
    );
  }
}
