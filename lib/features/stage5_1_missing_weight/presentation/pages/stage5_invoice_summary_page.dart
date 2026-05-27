// stage5_invoice_summary_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/pdf/helpers/generate_invoice_pdf.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:registro_panela/features/stage5/domain/entities/stage5_invoice_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/sync_stage51_payments_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';

class Stage5InvoiceSummaryPage extends ConsumerWidget {
  final Stage5InvoiceData invoice;
  const Stage5InvoiceSummaryPage({required this.invoice, super.key});
  Future<void> onShare(
    Stage5InvoiceData invoice,
    String projectName,
    List<PaymentData> installments,
  ) async {
    await generateAndShareInvoicePdf(invoice, projectName, installments);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final total = invoice.lines.fold<double>(0, (s, l) => s + l.subtotal);
    final project = ref.watch(stage1ProjectByIdProvider(invoice.projectId));
    final projectName = project?.name ?? '';

    final allInstallments = ref.watch(syncStage51PaymentsProvider);
    final installments = allInstallments
        .where((e) => e.projectId == invoice.projectId)
        .toList();
    final totalInstallments = installments.fold<double>(
      0,
      (s, e) => s + e.amount,
    );
    final totalToPay = total - totalInstallments;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('FACTURA', style: textTheme.headlineMedium),
        actions: [
          IconButton(
            key: const Key('stage5-invoice-share-button'),
            icon: const Icon(Icons.share),
            onPressed: () => onShare(invoice, projectName, installments),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPanelaBrown.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: AppColors.primaryPanelaBrown,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Factura generada',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryPanelaBrown,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          DateFormat.yMd().format(invoice.date),
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textDark.withAlpha(140),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.small),

            // ── Líneas por calidad ──
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 6),
              child: Text(
                'DETALLE POR CALIDAD',
                style: textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.1,
                  color: Colors.grey,
                ),
              ),
            ),
            ...invoice.lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
                child: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    child: Column(
                      children: [
                        // Badge calidad
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _qualityColor(
                                  line.quality,
                                ).withAlpha(30),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.small,
                                ),
                              ),
                              child: Text(
                                line.quality.label,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: _qualityColor(line.quality),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        _InvoiceRow(
                          label: 'Total kg',
                          value: '${line.totalKg} kg',
                        ),
                        _InvoiceRow(
                          label: 'Bultos',
                          value: line.bultos.toStringAsFixed(2),
                        ),
                        _InvoiceRow(
                          label: 'Precio por bulto',
                          value: '\$ ${moneyFormat(line.pricePerBulto)}',
                        ),
                        const Divider(height: 16, thickness: 0.5),
                        _InvoiceRow(
                          label: 'Subtotal',
                          value: '\$ ${moneyFormat(line.subtotal)}',
                          highlighted: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ── Abonos ──
            if (installments.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.small),
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 6),
                child: Text(
                  'ABONOS',
                  style: textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.1,
                    color: Colors.grey,
                  ),
                ),
              ),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Column(
                    children: [
                      ...installments.map(
                        (e) => _InvoiceRow(
                          label: DateFormat.yMd().format(e.date),
                          value: '\$ ${moneyFormat(e.amount)}',
                        ),
                      ),
                      const Divider(height: 16, thickness: 0.5),
                      _InvoiceRow(
                        label: 'Total abonado',
                        value: '\$ ${moneyFormat(totalInstallments)}',
                        highlighted: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.small),

            // ── Total neto ──
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Column(
                  children: [
                    _InvoiceRow(
                      label: 'Total bruto',
                      value: '\$ ${moneyFormat(total)}',
                    ),
                    _InvoiceRow(
                      label: 'Total abonado',
                      value: '- \$ ${moneyFormat(totalInstallments)}',
                    ),
                    const Divider(height: 16, thickness: 0.5),
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),

            // ── Botón PDF ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                key: const Key('stage5-invoice-pdf-button'),
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColors.textLight,
                ),
                label: Text(
                  'Generar PDF',
                  style: TextStyle(
                    fontFamily: AppTypography.familyRoboto,
                    fontSize: AppTypography.h4,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
                onPressed: () => generateAndShareInvoicePdf(
                  invoice,
                  projectName,
                  installments,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.medium),
          ],
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _InvoiceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _InvoiceRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: highlighted
                    ? AppColors.textDark
                    : AppColors.textDark.withAlpha(160),
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              color: highlighted
                  ? AppColors.primaryPanelaBrown
                  : AppColors.textDark,
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
