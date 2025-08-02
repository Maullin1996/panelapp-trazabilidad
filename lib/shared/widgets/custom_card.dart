import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: EdgeInsets.all(AppSpacing.smallLarge),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ), // Bordes redondeados
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: child,
      ),
    );
  }
}
