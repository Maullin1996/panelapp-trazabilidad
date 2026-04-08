import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage51_price_per_kilo_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/sync_stage51_payments_provider.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:uuid/uuid.dart';

import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_input_formatter.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage5_price_form_state_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';

class FormTotalToPay extends ConsumerStatefulWidget {
  final double totalRegisteredWeight;
  final String projectId;
  final VoidCallback? onPriceCalculated;

  const FormTotalToPay({
    super.key,
    this.totalRegisteredWeight = 0,
    required this.projectId,
    this.onPriceCalculated,
  });

  @override
  ConsumerState<FormTotalToPay> createState() => _FormTotalToPayState();
}

class _FormTotalToPayState extends ConsumerState<FormTotalToPay>
    with SingleTickerProviderStateMixin {
  final _formKeyAmount = GlobalKey<FormBuilderState>();
  final _formKeyPrice = GlobalKey<FormBuilderState>();
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
    final pricePerKilo = ref.watch(
      stage5PricePerKiloProvider(widget.projectId),
    );
    final formNotifier = ref.watch(stage5PriceFormProvider.notifier);
    final allInstallments = ref.watch(syncStage51PaymentsProvider);
    final installments = allInstallments
        .where((e) => e.projectId == widget.projectId)
        .toList();
    final totalInstallments = installments.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final totalWeight = widget.totalRegisteredWeight;
    final totalToPay = (pricePerKilo ?? 0) * totalWeight - totalInstallments;

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
                )
              : const SizedBox.shrink(),
        ),

        const SizedBox(height: AppSpacing.xSmall),

        // ── Sección "Calcular factura" ──
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            'CALCULAR FACTURA',
            style: textTheme.labelSmall?.copyWith(
              letterSpacing: 1.1,
              color: Colors.grey,
            ),
          ),
        ),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Valor por kilo', style: textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xSmall),
              FormBuilder(
                key: _formKeyPrice,
                child: AppFormTextFild(
                  key: const Key('stage5-form-total-to-pay-price-input'),
                  name: 'pricePerKilo',
                  keyboardType: TextInputType.number,
                  hintText: '\$ 0',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requerido';
                    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                    final parsed = double.tryParse(digitsOnly);
                    if (parsed == null) return 'Debe ser un número válido';
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
              const SizedBox(height: AppSpacing.small),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  key: const Key('stage5-form-total-to-pay-calculate-button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPanelaBrown,
                    foregroundColor: AppColors.textLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (!(_formKeyPrice.currentState?.saveAndValidate() ??
                        false)) {
                      return;
                    }
                    final values = _formKeyPrice.currentState!.value;
                    final price = values['pricePerKilo'] as double;
                    ref
                        .read(
                          stage5PricePerKiloProvider(widget.projectId).notifier,
                        )
                        .setPrice(price);
                    widget.onPriceCalculated?.call();
                  },
                  child: Text(
                    'Calcular',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Resumen de factura ──
        if (pricePerKilo != null) ...[
          const SizedBox(height: AppSpacing.xSmall),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 6),
            child: Text(
              'RESUMEN DE FACTURA',
              style: textTheme.labelSmall?.copyWith(
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
          ),
          CustomCard(
            child: Column(
              children: [
                _SummaryRow(
                  icon: Icons.monitor_weight_outlined,
                  iconColor: AppColors.weight,
                  label: 'Peso registrado',
                  value: '${totalWeight.toStringAsFixed(2)} kg',
                ),
                _SummaryRow(
                  icon: Icons.attach_money,
                  iconColor: AppColors.accepted,
                  label: 'Valor por kilo',
                  value: '\$ ${moneyFormat(pricePerKilo)}',
                ),
                _SummaryRow(
                  icon: Icons.calculate_outlined,
                  iconColor: AppColors.accepted,
                  label: 'Total bruto',
                  value: '\$ ${moneyFormat(pricePerKilo * totalWeight)}',
                ),
                _SummaryRow(
                  icon: Icons.remove_circle_outline,
                  iconColor: AppColors.accentLightPanela,
                  label: 'Total abonado',
                  value: '\$ ${moneyFormat(totalInstallments)}',
                ),
                const Divider(height: 20, thickness: 0.5),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        size: 15,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xSmall),
                    Expanded(
                      child: Text(
                        'Total a pagar',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '\$ ${moneyFormat(totalToPay)}',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(35),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.xSmall),
          Expanded(child: Text(label, style: textTheme.bodyMedium)),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
