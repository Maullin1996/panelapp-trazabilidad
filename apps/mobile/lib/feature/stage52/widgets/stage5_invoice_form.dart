// stage5_invoice_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:core/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:core/features/stage5/domain/entities/stage5_invoice_data.dart';
import 'package:core/features/stage5/providers/stage5_invoice_summary_provider.dart';
import 'package:core/features/stage5_1_missing_weight/helper/money_input_formatter.dart';
import 'package:core/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/app_form_text_fild.dart';
import 'package:core/shared/widgets/custom_card.dart';

class Stage5InvoiceForm extends ConsumerStatefulWidget {
  final String projectId;
  const Stage5InvoiceForm({required this.projectId, super.key});

  @override
  ConsumerState<Stage5InvoiceForm> createState() => _Stage5InvoiceFormState();
}

class _Stage5InvoiceFormState extends ConsumerState<Stage5InvoiceForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final summary = ref.watch(stage5InvoiceSummaryProvider(widget.projectId));

    // Solo mostramos calidades que tienen kg registrados
    final qualities = summary.kgByQuality.entries
        .where((e) => e.value > 0)
        .toList();

    if (qualities.isEmpty) {
      return Center(
        child: Text('No hay registros de pesaje', style: textTheme.bodyMedium),
      );
    }

    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Una fila por calidad ──
          ...qualities.map((entry) {
            final quality = entry.key;
            final kg = entry.value;
            final bultos = kg / 60;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header calidad
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _qualityColor(quality).withAlpha(30),
                              borderRadius: BorderRadius.circular(
                                AppRadius.small,
                              ),
                            ),
                            child: Text(
                              quality.label,
                              style: textTheme.bodyMedium?.copyWith(
                                color: _qualityColor(quality),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Chips de resumen
                          _InfoChip(
                            label: '${kg.toStringAsFixed(1)} kg',
                            icon: Icons.scale,
                          ),
                          const SizedBox(width: 6),
                          _InfoChip(
                            label: '${bultos.toStringAsFixed(2)} bultos',
                            icon: Icons.inventory_2,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.small),
                      // Campo precio por bulto
                      _LabeledField(
                        label: 'Precio por bulto',
                        textTheme: textTheme,
                        child: AppFormTextFild(
                          key: Key('invoice-price-${quality.name}'),
                          name: 'price_${quality.name}',
                          hintText: '\$ 0',
                          keyboardType: TextInputType.number,
                          inputFormatters: [MoneyInputFormatter()],
                          valueTransformer: (text) {
                            if (text == null) return null;
                            final digits = text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            return double.tryParse(digits);
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'Requerido',
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.small),

          // ── Botón generar ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const Key('stage5-invoice-generate-button'),
              onPressed: () => _onGenerate(summary),
              child: Text(
                'Generar factura',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onGenerate(InvoiceQualitySummary summary) {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    final values = _formKey.currentState!.value;

    final lines = <InvoiceQualityLine>[];
    for (final entry in summary.kgByQuality.entries) {
      final quality = entry.key;
      final kg = entry.value;
      if (kg <= 0) continue;

      final price = values['price_${quality.name}'] as double? ?? 0.0;
      final bultos = kg / 60;
      final subtotal = bultos * price;

      lines.add(
        InvoiceQualityLine(
          quality: quality,
          totalKg: kg.toInt(),
          bultos: bultos,
          pricePerBulto: price,
          subtotal: subtotal,
        ),
      );
    }

    final invoice = Stage5InvoiceData(
      id: const Uuid().v4(),
      projectId: widget.projectId,
      date: DateTime.now(),
      lines: lines,
    );

    // Navega al resumen de factura
    context.pushNamed(
      'stage5invoice',
      pathParameters: {'projectId': widget.projectId},
      extra: invoice,
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondaryDarkPanela.withAlpha(15),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.secondaryDarkPanela),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.h5,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryDarkPanela,
            ),
          ),
        ],
      ),
    );
  }
}

Color _qualityColor(BasketQuality quality) {
  return switch (quality) {
    BasketQuality.negra => AppColors.textDark,
    BasketQuality.regular => AppColors.alert,
    BasketQuality.buena => AppColors.accepted,
    BasketQuality.extra => AppColors.primaryPanelaBrown,
  };
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextTheme textTheme;
  final Widget child;

  const _LabeledField({
    required this.label,
    required this.textTheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textDark.withAlpha(140),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xSmall),
        child,
      ],
    );
  }
}
