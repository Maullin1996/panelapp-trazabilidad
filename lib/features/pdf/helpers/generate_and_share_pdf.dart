import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:registro_panela/shared/utils/typography.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

// Mapea tus tamaños a puntos del PDF (un poco más grandes para impresión)
class PdfTypography {
  static const double body = AppTypography.body; // 18
  static const double h5 = 14; // ↑ desde 12
  static const double h4 = 18; // ↑ desde 16
  static const double h3 = 22; // ↑ desde 20
  static const double h2 = 28; // ↑ desde 24
  static const double h1 = 34; // ↑ desde 30
}

Future<Uint8List> generatePdf(Stage1FormData project) async {
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

  pw.Widget vspace(double height) => pw.SizedBox(height: height);
  pw.Widget cardContainer(pw.Widget child) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(width: 0.7, color: borderColor),
      ),
      child: child,
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Recursos suministrados', style: tTitle),
                    vspace(6),
                    pw.Text(
                      '${project.name} · ${DateFormat.yMd().format(project.date)}',
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
                    color: PdfColors.white,
                    border: pw.Border.all(width: 0.8, color: borderColor),
                  ),
                  child: pw.Text('Stage 1', style: tSmall),
                ),
              ],
            ),
            vspace(18),
            pw.Divider(color: borderColor, thickness: 1),
            vspace(18),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: cardContainer(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Canastillas', style: tSection),
                        vspace(10),
                        pw.Text('${project.basketsQuantity}', style: tHeader),
                        vspace(4),
                        pw.Text('unidades registradas', style: tNote),
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
                        pw.Text('Gaveras', style: tSection),
                        vspace(10),
                        pw.Text('${project.gaveras.length}', style: tHeader),
                        vspace(4),
                        pw.Text('tipos registrados', style: tNote),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            vspace(24),

            pw.Text(
              'GAVERAS',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 12,
                color: subtitleColor,
                letterSpacing: 1.2,
              ),
            ),
            vspace(12),
            cardContainer(
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.white,
                    ),
                    child: pw.Table(
                      border: pw.TableBorder.symmetric(
                        outside: pw.BorderSide(color: borderColor, width: 0.8),
                      ),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(1.5),
                        1: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text('Cantidad', style: tSmall),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                'Peso referencia (g)',
                                style: tSmall,
                              ),
                            ),
                          ],
                        ),
                        ...project.gaveras.map(
                          (g) => pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                child: pw.Text('${g.quantity}', style: tBody),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                child: pw.Text(
                                  '${g.referenceWeight} g',
                                  style: tBody,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            vspace(24),

            pw.Text(
              'MATERIALES ADICIONALES',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 12,
                color: subtitleColor,
                letterSpacing: 1.2,
              ),
            ),
            vspace(12),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: cardContainer(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Conservantes', style: tSection),
                        vspace(10),
                        pw.Text(
                          '${project.preservativesWeight} kg',
                          style: tHeader,
                        ),
                        vspace(4),
                        pw.Text(
                          '${project.preservativesJars} tarros',
                          style: tNote,
                        ),
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
                        pw.Text('Cal', style: tSection),
                        vspace(10),
                        pw.Text('${project.limeWeight} kg', style: tHeader),
                        vspace(4),
                        pw.Text('${project.limeJars} tarros', style: tNote),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            vspace(28),

            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(width: 0.7, color: borderColor),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 42,
                    height: 42,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFE5D9C8),
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        project.name.isNotEmpty
                            ? project.name[0].toUpperCase()
                            : 'P',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 18,
                          color: baseColor,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        project.name,
                        style: tBody.copyWith(fontWeight: pw.FontWeight.bold),
                      ),
                      vspace(4),
                      pw.Text(project.phone, style: tNote),
                    ],
                  ),
                ],
              ),
            ),
            vspace(16),
            pw.Divider(color: borderColor, thickness: 0.8),
            vspace(8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'registro_panela · generado automáticamente',
                  style: tNote,
                ),
                pw.Text('1/1', style: tNote),
              ],
            ),
          ],
        );
      },
    ),
  );

  final bytes = await pdf.save();
  return bytes;
}

Future<void> generateAndSharePdf(Stage1FormData project) async {
  final bytes = await generatePdf(project);
  await Printing.sharePdf(bytes: bytes, filename: 'proyecto_${project.id}.pdf');
}
