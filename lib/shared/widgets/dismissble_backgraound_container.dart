import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/spacing.dart';

class DismissbleBackgraoundContainer extends StatelessWidget {
  const DismissbleBackgraoundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.smallLarge),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }
}
