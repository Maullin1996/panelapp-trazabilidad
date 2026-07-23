import 'package:flutter/material.dart';
import '../../core/theme/utils/tokens.dart';

class SelectionSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SelectionSourceTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.xSmall,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.secondaryDarkPanela.withAlpha(60),
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPanelaBrown, size: 24),
            const SizedBox(width: AppSpacing.xSmall),
            Text(label, style: textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
