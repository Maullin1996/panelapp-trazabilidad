import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';

class TwoFormsRow extends StatelessWidget {
  final String nameFirst;
  final String labeFirst;
  final String nameSecond;
  final String labeSecond;

  const TwoFormsRow({
    super.key,
    required this.nameFirst,
    required this.labeFirst,
    required this.nameSecond,
    required this.labeSecond,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labeFirst, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.small),
              AppFormTextFild(
                name: nameFirst,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                ]),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            children: [
              Text(labeSecond, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.small),
              AppFormTextFild(
                name: nameSecond,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                ]),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
