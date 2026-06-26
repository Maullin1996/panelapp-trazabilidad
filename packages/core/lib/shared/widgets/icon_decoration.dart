import 'package:flutter/material.dart';
import '../utils/tokens.dart';

class IconDecoration extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double? size;
  final bool backgroundDecoration;
  const IconDecoration({
    super.key,
    this.backgroundColor = AppColors.secondaryDarkPanela,
    required this.icon,
    required this.iconColor, this.size = 15, 
    this.backgroundDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xSmall),
      decoration: backgroundDecoration
          ? BoxDecoration(
              color: backgroundColor.withAlpha(40),
              borderRadius: BorderRadius.circular(AppRadius.small),
            )
          : null,
      child: Icon(icon, size: size, color: iconColor),
    );
  }
}
