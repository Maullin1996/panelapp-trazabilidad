import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/spacing.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final IconData? icon;
  final Color? iconColor;
  const CustomRichText({
    super.key,
    this.iconColor,
    required this.firstText,
    required this.secondText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: AppSpacing.xSmall),
        Expanded(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(style: textTheme.headlineMedium, text: firstText),
                TextSpan(style: textTheme.bodyLarge, text: secondText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
