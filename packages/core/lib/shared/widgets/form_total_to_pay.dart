import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:core/core/services/custom_snack_bar.dart';
import 'package:core/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:core/shared/widgets/custom_card.dart';
import 'package:core/features/stage5_1_missing_weight/helper/money_input_formatter.dart';
import 'package:core/features/stage5_1_missing_weight/providers/stage5_price_form_state_provider.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/app_form_text_fild.dart';

class FormTotalToPay extends ConsumerStatefulWidget {
  final String projectId;

  const FormTotalToPay({super.key, required this.projectId});

  @override
  ConsumerState<FormTotalToPay> createState() => _FormTotalToPayState();
}

class _FormTotalToPayState extends ConsumerState<FormTotalToPay>
    with SingleTickerProviderStateMixin {
  final _formKeyAmount = GlobalKey<FormBuilderState>();
  bool showForm = false;
  final uuid = Uuid();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() => showForm = !showForm);
    if (showForm) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final formNotifier = ref.watch(stage5PriceFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Botón "Registrar abono" ──
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              key: const Key('stage5-form-total-to-pay-add-installment-button'),
              onPressed: _toggleForm,
              icon: Icon(
                showForm ? Icons.close : Icons.add,
                size: 20,
                color: AppColors.textLight,
              ),
              label: Text(
                showForm ? 'Cancelar' : 'Registrar abono',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textDark,
                backgroundColor: AppColors.primaryPanelaBrown,
                side: BorderSide(color: AppColors.secondaryDarkPanela),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
            ),
          ),
        ),

        // ── Panel animado de abono ──
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: showForm
              ? FadeTransition(
                  opacity: _fadeAnim,
                  child: CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.small),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monto del abono', style: textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.xSmall),
                          FormBuilder(
                            key: _formKeyAmount,
                            child: AppFormTextFild(
                              key: const Key(
                                'stage5-form-total-to-pay-add-installment-input',
                              ),
                              name: 'amount',
                              keyboardType: TextInputType.number,
                              hintText: '\$ 0',
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
                          const SizedBox(height: AppSpacing.small),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              key: const Key(
                                'stage5-form-total-to-pay-save-button',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPanelaBrown,
                                foregroundColor: AppColors.textLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.large,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Guardar abono',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!(_formKeyAmount.currentState
                                        ?.saveAndValidate() ??
                                    false)) {
                                  return;
                                }

                                final messenger = ScaffoldMessenger.of(context);
                                final val = _formKeyAmount.currentState!.value;
                                final amount = double.parse(val['amount']);
                                final payment = PaymentData(
                                  id: uuid.v4(),
                                  projectId: widget.projectId,
                                  date: DateTime.now(),
                                  amount: amount,
                                );

                                final success = await formNotifier.submit(
                                  data: payment,
                                );
                                if (!mounted) return;
                                if (success) {
                                  CustomSnackBar.showWithMessenger(
                                    messenger,
                                    message: 'Abono registrado exitosamente',
                                    status: SnackbarStatus.accepted,
                                  );
                                  _toggleForm();
                                } else {
                                  CustomSnackBar.showWithMessenger(
                                    messenger,
                                    message: 'Error al registrar el abono',
                                    status: SnackbarStatus.error,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        const SizedBox(height: AppSpacing.xSmall),
      ],
    );
  }
}
