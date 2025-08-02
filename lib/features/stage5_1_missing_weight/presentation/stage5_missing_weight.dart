import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/stage5_price_form.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_input_formatter.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/global_missing_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage5_price_form_state_provider.dart';
import 'package:registro_panela/shared/utils/colors.dart';
import 'package:registro_panela/shared/utils/spacing.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';
import 'package:uuid/uuid.dart';

class Stage5MissingWeight extends ConsumerWidget {
  final String projectId;
  const Stage5MissingWeight({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary3 = ref.watch(stage3GlobalSummaryProvider(projectId));
    final textTheme = TextTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppSpacing.medium),
      child: Column(
        children: [
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                children: [
                  Text(
                    'Total registrado en moliendas',
                    maxLines: 2,
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.smallLarge),
                  CustomRichText(
                    icon: Icons.shopping_basket,
                    iconColor: AppColors.register,
                    firstText: 'Canastillas esperadas: ',
                    secondText: '${summary3.totalExpectedCount}',
                  ),
                  CustomRichText(
                    icon: Icons.scale,
                    iconColor: AppColors.weight,
                    firstText: 'Peso esperado: ',
                    secondText:
                        '${summary3.totalExpectedWeight.toStringAsFixed(2)} kg',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                children: [
                  Text(
                    'Total registrado en bodega',
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.smallLarge),
                  CustomRichText(
                    icon: Icons.all_inbox_rounded,
                    iconColor: AppColors.register,
                    firstText: 'Registradas: ',
                    secondText: '${summary3.totalRegisteredCount} Canastillas',
                  ),
                  CustomRichText(
                    icon: Icons.check_box,
                    iconColor: AppColors.accepted,
                    firstText: 'Peso registrado: ',
                    secondText:
                        '${summary3.totalRegisteredWeight.toStringAsFixed(2)} kg',
                  ),
                ],
              ),
            ),
          ),

          if (summary3.totalMissingCount != 0 ||
              summary3.totalMissingWeight != 0)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Total Faltante',
                        style: textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.smallLarge),

                    if (summary3.totalMissingCount != 0)
                      CustomRichText(
                        firstText: 'Faltan: ',
                        secondText: '${summary3.totalMissingCount} Canastillas',
                        icon: Icons.priority_high,
                        iconColor: AppColors.error,
                      ),
                    if (summary3.totalMissingWeight != 0)
                      CustomRichText(
                        firstText: 'Peso Faltante: ',
                        secondText:
                            '${summary3.totalMissingWeight.toStringAsFixed(2)} kg',
                        icon: Icons.warning,
                        iconColor: AppColors.alert,
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.smallMedium),
          _FormTotalToPay(
            projectId: projectId,
            totalRegisteredWeight: summary3.totalRegisteredWeight,
          ),
        ],
      ),
    );
  }
}

class _FormTotalToPay extends ConsumerStatefulWidget {
  final double totalRegisteredWeight;
  final String projectId;
  const _FormTotalToPay({
    this.totalRegisteredWeight = 0,
    required this.projectId,
  });

  @override
  ConsumerState<_FormTotalToPay> createState() => __FormTotalToPayState();
}

class __FormTotalToPayState extends ConsumerState<_FormTotalToPay> {
  final _formKey = GlobalKey<FormBuilderState>();
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final formState = ref.watch(stage5PriceFormProvider);
    final formNotifier = ref.read(stage5PriceFormProvider.notifier);

    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Total a pagar', style: textTheme.headlineLarge),
            ),
            const SizedBox(height: AppSpacing.smallMedium),
            Text('Valor por kilo', style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xSmall),
            AppFormTextFild(
              name: 'pricePerKilo',
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
                FormBuilderValidators.min(1),
              ]),
              inputFormatters: [MoneyInputFormatter()],
              valueTransformer: (text) {
                if (text == null) return null;
                return text.replaceAll(RegExp(r'[^0-9]'), '');
              },
            ),
            const SizedBox(height: AppSpacing.smallMedium),
            Text('Se realizaron abonos', style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xSmall),
            AppFormTextFild(
              name: 'installment',
              keyboardType: TextInputType.number,
              inputFormatters: [MoneyInputFormatter()],
              valueTransformer: (text) {
                if (text == null) return null;
                return text.replaceAll(RegExp(r'[^0-9]'), '');
              },
            ),
            const SizedBox(height: AppSpacing.medium),
            if (formState.data != null)
              Column(
                children: [
                  CustomRichText(
                    icon: Icons.money_off,
                    firstText: 'Valor total: ',
                    secondText: '\$ ${moneyFormat(formState.totalToPay)}',
                  ),
                  const SizedBox(height: AppSpacing.medium),
                ],
              ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: formState.status == Stage5PriceFormStatus.submitting
                    ? null
                    : () {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          return;
                        }

                        final values = _formKey.currentState!.value;

                        final data = Stage5PriceFormData(
                          id: uuid.v4(),
                          projectId: widget.projectId,
                          date: DateTime.now(),
                          pricePerKilo:
                              double.tryParse(values['pricePerKilo'] ?? '0') ??
                              0.0,
                          installment:
                              double.tryParse(values['installment'] ?? '0') ??
                              0.0,
                        );
                        formNotifier.submit(
                          projectId: widget.projectId,
                          data: data,
                          totalRegisteredWeight: widget.totalRegisteredWeight,
                        );
                      },
                child: Text('Calcular', style: textTheme.headlineLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
