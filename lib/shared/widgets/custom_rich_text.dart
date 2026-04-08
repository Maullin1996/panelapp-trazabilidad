import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/colors.dart';
import 'package:registro_panela/shared/utils/spacing.dart';
import 'package:registro_panela/shared/widgets/icon_decoration.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color? firstTextColor;
  final Color? secondTextColor;
  final IconData? icon;
  final Color iconColor;
  const CustomRichText({
    super.key,
    this.iconColor = AppColors.textDark,
    required this.firstText,
    required this.secondText,
    this.firstTextColor,
    this.secondTextColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          IconDecoration(
            icon: icon ?? Icons.inbox,
            iconColor: iconColor,
            backgroundColor: iconColor,
          ),
        const SizedBox(width: AppSpacing.xSmall),
        Expanded(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  style: textTheme.headlineLarge?.copyWith(
                    color: firstTextColor,
                  ),
                  text: firstText,
                ),
                TextSpan(
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: secondTextColor,
                  ),
                  text: secondText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
