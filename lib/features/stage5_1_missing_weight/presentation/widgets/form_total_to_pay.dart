import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/sync_stage51_payments_provider.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';
import 'package:uuid/uuid.dart';

import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_input_formatter.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage5_price_form_state_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';

class FormTotalToPay extends ConsumerStatefulWidget {
  final double totalRegisteredWeight;
  final String projectId;
  final ScrollController controller;
  const FormTotalToPay({
    super.key,
    this.totalRegisteredWeight = 0,
    required this.projectId,
    required this.controller,
  });

  @override
  ConsumerState<FormTotalToPay> createState() => _FormTotalToPayState();
}

class _FormTotalToPayState extends ConsumerState<FormTotalToPay> {
  final _formKeyAmount = GlobalKey<FormBuilderState>();
  final _formKeyPrice = GlobalKey<FormBuilderState>();
  bool showForm = false;
  double? _pricePerKilo;
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final formState = ref.watch(stage5PriceFormProvider);
    final formNotifier = ref.read(stage5PriceFormProvider.notifier);
    final allInstallments = ref.watch(syncStage51PaymentsProvider);
    final installments = allInstallments
        .where((e) => e.projectId == widget.projectId)
        .toList();
    final totalInstallments = installments.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final totalWeight = widget.totalRegisteredWeight;
    final totalToPay = (_pricePerKilo ?? 0) * totalWeight - totalInstallments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Realizar Abono',
                      style: textTheme.headlineLarge,
                    ),
                  ),
                  IconButton(
                    key: Key('stage5-form-total-to-pay-add-installment-button'),
                    onPressed: () {
                      setState(() => showForm = !showForm);
                    },
                    icon: Icon(
                      showForm ? Icons.close : Icons.add,
                      size: 30,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: showForm
                    ? Column(
                        children: [
                          FormBuilder(
                            key: _formKeyAmount,
                            child: AppFormTextFild(
                              key: Key(
                                'stage5-form-total-to-pay-add-installment-input',
                              ),
                              name: 'amount',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requerido';
                                }
                                final digitsOnly = value.replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                );
                                final parsed = double.tryParse(digitsOnly);
                                if (parsed == null) {
                                  return 'Debe ser un número válido';
                                }
                                if (parsed < 1) return 'Debe ser mayor que 0';
                                return null;
                              },
                              inputFormatters: [MoneyInputFormatter()],
                              valueTransformer: (text) {
                                if (text == null) return null;
                                return text.replaceAll(RegExp(r'[^0-9]'), '');
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.smallLarge),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              key: Key('stage5-form-total-to-pay-save-button'),
                              child: Text(
                                'Guardar abono',
                                style: textTheme.headlineLarge,
                              ),
                              onPressed: () {
                                if (!(_formKeyAmount.currentState
                                        ?.saveAndValidate() ??
                                    false)) {
                                  return;
                                }
                                final val = _formKeyAmount.currentState!.value;
                                final amount = double.parse(val['amount']);
                                final payment = PaymentData(
                                  id: uuid.v4(),
                                  projectId: widget.projectId,
                                  date: DateTime.now(),
                                  amount: amount,
                                );
                                formNotifier.submit(data: payment);
                                setState(() {
                                  showForm = !showForm;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.medium),
                        ],
                      )
                    : const SizedBox(height: AppSpacing.smallLarge),
              ),
              Text('Valor por kilo', style: textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.xSmall),
              FormBuilder(
                key: _formKeyPrice,
                child: AppFormTextFild(
                  key: Key('stage5-form-total-to-pay-price-input'),
                  name: 'pricePerKilo',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requerido';
                    }
                    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                    final parsed = double.tryParse(digitsOnly);
                    if (parsed == null) {
                      return 'Debe ser un número válido';
                    }
                    if (parsed < 1) return 'Debe ser mayor que 0';
                    return null;
                  },
                  inputFormatters: [MoneyInputFormatter()],
                  valueTransformer: (text) {
                    if (text == null) return null;
                    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
                    return double.tryParse(digitsOnly);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.medium),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  key: Key('stage5-form-total-to-pay-calculate-button'),
                  onPressed:
                      formState.status == Stage5PriceFormStatus.submitting
                      ? null
                      : () {
                          if (!(_formKeyPrice.currentState?.saveAndValidate() ??
                              false)) {
                            return;
                          }
                          final values = _formKeyPrice.currentState!.value;
                          final price = values['pricePerKilo'] as double;
                          setState(() {
                            _pricePerKilo = price;
                          });

                          widget.controller.animateTo(
                            widget.controller.offset + 200,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        },
                  child: Text('Calcular', style: textTheme.headlineLarge),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.smallLarge),
        if (_pricePerKilo != null)
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen de factura', style: textTheme.headlineLarge),
                const SizedBox(height: AppSpacing.mediumSmall),
                CustomRichText(
                  icon: Icons.line_weight,
                  iconColor: AppColors.weight,
                  firstText: 'Peso registrado: ',
                  secondText: '${totalWeight.toStringAsFixed(2)} kg',
                ),
                CustomRichText(
                  icon: Icons.attach_money,
                  iconColor: AppColors.accepted,
                  firstText: 'Valor por kilo: ',
                  secondText: '\$ ${moneyFormat(_pricePerKilo!)}',
                ),
                CustomRichText(
                  icon: Icons.payments,
                  iconColor: AppColors.accepted,
                  firstText: 'Total bruto: ',
                  secondText: '\$ ${moneyFormat(_pricePerKilo! * totalWeight)}',
                ),
                CustomRichText(
                  icon: Icons.money_off,
                  iconColor: AppColors.accentLightPanela,
                  firstText: 'Total abonado: ',
                  secondText: '\$ ${moneyFormat(totalInstallments)}',
                ),
                const Divider(),
                CustomRichText(
                  icon: Icons.receipt_long,
                  iconColor: AppColors.error,
                  firstText: 'Total a pagar: ',
                  secondText: '\$ ${moneyFormat(totalToPay)}',
                ),
              ],
            ),
          ),
      ],
    );
  }
}
