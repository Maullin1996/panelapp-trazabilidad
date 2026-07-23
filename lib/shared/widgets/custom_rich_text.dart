import 'package:flutter/material.dart';
import '../../core/theme/utils/colors.dart';
import '../../core/theme/utils/spacing.dart';
import 'icon_decoration.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color? firstTextColor;
  final Color? secondTextColor;
  final IconData? icon;
  final Color iconColor;
  final double? size;
  final bool? backgroundDecoration;
  final TextStyle? textStyle;
  const CustomRichText({
    super.key,
    this.iconColor = AppColors.textDark,
    required this.firstText,
    required this.secondText,
    this.firstTextColor,
    this.secondTextColor,
    this.icon,
    this.size = 15,
    this.backgroundDecoration,
    this.textStyle,
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
            backgroundDecoration: backgroundDecoration ?? true,
            size: size,
          ),
        const SizedBox(width: AppSpacing.xSmall),
        Expanded(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  style:
                      textStyle ??
                      textTheme.headlineMedium?.copyWith(color: firstTextColor),
                  text: firstText,
                ),
                TextSpan(
                  style:
                      textStyle ??
                      textTheme.headlineMedium?.copyWith(
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
