import 'package:flutter/material.dart';
import '../utils/colors.dart';

class FieldLabel extends StatelessWidget {
  final TextTheme textTheme;
  final String label;

  const FieldLabel(this.textTheme, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.textDark.withAlpha(180),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
