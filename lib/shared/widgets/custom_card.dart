import 'package:flutter/material.dart';
import '../../core/theme/utils/tokens.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color isSelected;
  const CustomCard({
    super.key,
    required this.child,
    this.isSelected = AppColors.cardBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ), // Bordes redondeados
      ),
      child: child,
    );
  }
}
