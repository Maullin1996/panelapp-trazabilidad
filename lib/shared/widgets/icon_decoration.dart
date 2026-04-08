import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class IconDecoration extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  const IconDecoration({
    super.key,
    this.backgroundColor = AppColors.secondaryDarkPanela,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xSmall),
      decoration: BoxDecoration(
        color: backgroundColor.withAlpha(40),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Icon(icon, size: 15, color: iconColor),
    );
  }
}
