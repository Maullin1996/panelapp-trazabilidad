// generate_invoice_pdf.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'web_download_stub.dart' if (dart.library.html) 'web_download.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:registro_panela/features/stage5/domain/entities/stage5_invoice_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';

Future<Uint8List> generateInvoicePdf(
  Stage5InvoiceData invoice,
  String projectName,
  List<PaymentData> installments,
) async {
  final fontRegular = pw.Font.ttf(
    await rootBundle.load(
      'assets/fonts/Roboto-Italic-VariableFont_wdth,wght.ttf',
    ),
  );
  final fontBold = pw.Font.ttf(
    await rootBundle.load(
      'assets/fonts/Roboto-Italic-VariableFont_wdth,wght.ttf',
    ),
  );
  final totalInstallments = installments.fold<double>(
    0,
    (s, e) => s + e.amount,
  );

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
  );

  final baseColor = PdfColor.fromInt(0xFF9F7E38);
  final borderColor = PdfColor.fromInt(0xFFE2D0B5);
  final subtitleColor = PdfColor.fromInt(0xFF6F5B40);

  final tTitle = pw.TextStyle(
    font: fontBold,
    fontSize: 30,
    color: PdfColors.black,
  );
  final tSection = pw.TextStyle(font: fontBold, fontSize: 14, color: baseColor);
  final tHeader = pw.TextStyle(
    font: fontBold,
    fontSize: 18,
    color: PdfColors.black,
  );
  final tBody = pw.TextStyle(
    font: fontRegular,
    fontSize: 12,
    color: PdfColors.black,
  );
  final tNote = pw.TextStyle(
    font: fontRegular,
    fontSize: 10,
    color: subtitleColor,
  );
  final tSmall = pw.TextStyle(
    font: fontBold,
    fontSize: 12,
    color: subtitleColor,
  );

  pw.Widget vspace(double h) => pw.SizedBox(height: h);

  pw.Widget cardContainer(pw.Widget child) => pw.Container(
    padding: const pw.EdgeInsets.all(14),
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      borderRadius: pw.BorderRadius.circular(12),
      border: pw.Border.all(width: 0.7, color: borderColor),
    ),
    child: child,
  );

  final total = invoice.lines.fold<double>(0, (s, l) => s + l.subtotal);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      build: (pw.Context context) => [
        // ── Header ──
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Factura de venta', style: tTitle),
                vspace(6),
                pw.Text(
                  '$projectName · ${DateFormat.yMd().format(invoice.date)}',
                  style: tBody,
                ),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(width: 0.8, color: borderColor),
              ),
              child: pw.Text('Stage 5', style: tSmall),
            ),
          ],
        ),
        vspace(18),
        pw.Divider(color: borderColor, thickness: 1),
        vspace(18),

        // ── Resumen total ──
        pw.Row(
          children: [
            pw.Expanded(
              child: cardContainer(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Total bultos', style: tSection),
                    vspace(8),
                    pw.Text(
                      invoice.lines
                          .fold<double>(0, (s, l) => s + l.bultos)
                          .toStringAsFixed(2),
                      style: tHeader,
                    ),
                    vspace(4),
                    pw.Text('de todas las calidades', style: tNote),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: cardContainer(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Total a pagar', style: tSection),
                    vspace(8),
                    pw.Text('\$ ${moneyFormat(total)}', style: tHeader),
                    vspace(4),
                    pw.Text('suma de todas las calidades', style: tNote),
                  ],
                ),
              ),
            ),
          ],
        ),
        vspace(24),

        // ── Detalle por calidad ──
        pw.Text(
          'DETALLE POR CALIDAD',
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 12,
            color: subtitleColor,
            letterSpacing: 1.2,
          ),
        ),
        vspace(12),
        cardContainer(
          pw.Table(
            border: pw.TableBorder.symmetric(
              outside: pw.BorderSide(color: borderColor, width: 0.8),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _cell('Calidad', tSmall),
                  _cell('Total kg', tSmall),
                  _cell('Bultos', tSmall),
                  _cell('Precio/bulto', tSmall),
                  _cell('Subtotal', tSmall),
                ],
              ),
              ...invoice.lines.map(
                (line) => pw.TableRow(
                  children: [
                    _cell(line.quality.label, tBody),
                    _cell('${line.totalKg} kg', tBody),
                    _cell(line.bultos.toStringAsFixed(2), tBody),
                    _cell('\$ ${moneyFormat(line.pricePerBulto)}', tBody),
                    _cell('\$ ${moneyFormat(line.subtotal)}', tBody),
                  ],
                ),
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _cell('TOTAL', tSmall),
                  _cell(
                    '${invoice.lines.fold<int>(0, (s, l) => s + l.totalKg)} kg',
                    tSmall,
                  ),
                  _cell(
                    invoice.lines
                        .fold<double>(0, (s, l) => s + l.bultos)
                        .toStringAsFixed(2),
                    tSmall,
                  ),
                  _cell('', tSmall),
                  _cell('\$ ${moneyFormat(total)}', tSmall),
                ],
              ),
            ],
          ),
        ),

        // ── Abonos ──
        if (installments.isNotEmpty) ...[
          vspace(24),
          pw.Text(
            'ABONOS',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 12,
              color: subtitleColor,
              letterSpacing: 1.2,
            ),
          ),
          vspace(12),
          cardContainer(
            pw.Table(
              border: pw.TableBorder.symmetric(
                outside: pw.BorderSide(color: borderColor, width: 0.8),
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [_cell('Fecha', tSmall), _cell('Monto', tSmall)],
                ),
                ...installments.map(
                  (e) => pw.TableRow(
                    children: [
                      _cell(DateFormat.yMd().format(e.date), tBody),
                      _cell('\$ ${moneyFormat(e.amount)}', tBody),
                    ],
                  ),
                ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _cell('Total abonado', tSmall),
                    _cell('\$ ${moneyFormat(totalInstallments)}', tSmall),
                  ],
                ),
              ],
            ),
          ),
        ],
        vspace(24),

        // ── Total neto ──
        cardContainer(
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total bruto', style: tNote),
                  vspace(4),
                  pw.Text('\$ ${moneyFormat(total)}', style: tBody),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total abonado', style: tNote),
                  vspace(4),
                  pw.Text(
                    '- \$ ${moneyFormat(totalInstallments)}',
                    style: tBody,
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total a pagar', style: tNote),
                  vspace(4),
                  pw.Text(
                    '\$ ${moneyFormat(total - totalInstallments)}',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 18,
                      color: baseColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        vspace(40),

        // ── Firmas ──
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: double.infinity,
                    height: 1,
                    color: subtitleColor,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Firma administrador',
                    style: tNote,
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 40),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: double.infinity,
                    height: 1,
                    color: subtitleColor,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Firma recibido',
                    style: tNote,
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        vspace(28),
        pw.Divider(color: borderColor, thickness: 0.8),
        vspace(8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('registro_panela · generado automáticamente', style: tNote),
            pw.Text('1/1', style: tNote),
          ],
        ),
      ],
    ),
  );

  return pdf.save();
}

// Helper para celdas de tabla
pw.Widget _cell(String text, pw.TextStyle style) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: pw.Text(text, style: style),
  );
}

Future<void> generateAndShareInvoicePdf(
  Stage5InvoiceData invoice,
  String projectName,
  List<PaymentData> installments,
) async {
  final bytes = await generateInvoicePdf(invoice, projectName, installments);
  if (kIsWeb) {
    await downloadPdfInBrowser(bytes, 'factura_${invoice.projectId}.pdf');
  } else {
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'factura_${invoice.projectId}.pdf',
    );
  }
}
