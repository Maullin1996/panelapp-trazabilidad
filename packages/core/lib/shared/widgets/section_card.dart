import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'icon_decoration.dart';

import '../utils/tokens.dart';

class SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de sección
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.small,
              AppSpacing.small,
              AppSpacing.small,
              0,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: icon,
                  iconColor: iconColor,
                  backgroundColor: iconColor,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryPanelaBrown,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xSmall,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(30),
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.small,
              0,
              AppSpacing.small,
              AppSpacing.small,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
