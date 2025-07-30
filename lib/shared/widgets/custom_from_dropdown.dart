import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:registro_panela/shared/utils/tokens.dart';

class CustomFromDropdown extends StatelessWidget {
  final String name;
  final List<DropdownMenuItem> items;
  final String? Function(String?)? validator;
  const CustomFromDropdown({
    super.key,
    required this.name,
    required this.items,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.secondaryDarkPanela, width: 2),
      ),
      child: FormBuilderDropdown(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.small,
        ),
        name: name,
        items: items,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
