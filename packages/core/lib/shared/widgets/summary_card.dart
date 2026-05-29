import 'package:flutter/material.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.textTheme,
    required this.title,
    required this.firstTextCard1,
    required this.secondTextCard1,
    required this.firstTextCard2,
    required this.secondTextCard2,
    required this.firstIcon,
    required this.firstIconColors,
    required this.secondIconColors,
    required this.secondIcon,
  });

  final TextTheme textTheme;
  final String title;
  final String firstTextCard1;
  final String secondTextCard1;
  final String firstTextCard2;
  final String secondTextCard2;
  final IconData firstIcon;
  final IconData secondIcon;
  final Color firstIconColors;
  final Color secondIconColors;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: AppColors.primaryPanelaBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xSmall,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(45),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.small,
            ),
            child: Column(
              children: [
                CustomRichText(
                  icon: firstIcon,
                  iconColor: firstIconColors,
                  firstText: firstTextCard1,
                  secondText: secondTextCard1,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: secondIcon,
                  iconColor: secondIconColors,
                  firstText: firstTextCard2,
                  secondText: secondTextCard2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
