import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:registro_panela/shared/utils/spacing.dart';
import 'package:registro_panela/shared/utils/typography.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

// Mapea tus tamaños a puntos del PDF (un poco más grandes para impresión)
class PdfTypography {
  static const double body = AppTypography.body; // 18
  static const double h5 = 14; // ↑ desde 12
  static const double h4 = 18; // ↑ desde 16
  static const double h3 = 22; // ↑ desde 20
  static const double h2 = 28; // ↑ desde 24
  static const double h1 = 34; // ↑ desde 30
}

Future<void> generateAndSharePdf(Stage1FormData project) async {
  // 1) Cargar fuentes como pw.Font
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

  // 2) Crear documento con tema global
  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
  );

  // 3) Estilos usando tus tamaños
  final tH1 = pw.TextStyle(font: fontBold, fontSize: PdfTypography.h1);
  final tH2 = pw.TextStyle(font: fontBold, fontSize: PdfTypography.h2);
  final tH3 = pw.TextStyle(font: fontBold, fontSize: PdfTypography.h3);
  final tBody = pw.TextStyle(font: fontRegular, fontSize: PdfTypography.body);
  final tEmph = pw.TextStyle(font: fontBold, fontSize: PdfTypography.body);

  // Helper de spacer con tus AppSpacing (son px; en PDF igual funcionan en pt)
  pw.Widget vspace(double h) => pw.SizedBox(height: h);
  pw.Widget divider() => pw.Divider(thickness: 1);

  // 4) Página con márgenes cómodos
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28), // ~1cm
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Recursos suministrados', style: tH1),
            vspace(AppSpacing.smallLarge),

            // Encabezado del proyecto
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(width: 1, color: PdfColors.grey600),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Nombre: ${project.name}', style: tH3),
                  vspace(AppSpacing.xSmall),
                  pw.Text(
                    'Fecha: ${DateFormat.yMd().format(project.date)}',
                    style: tBody,
                  ),
                  vspace(AppSpacing.xSmall),
                  pw.Text('Teléfono: ${project.phone}', style: tBody),
                ],
              ),
            ),

            vspace(AppSpacing.mediumSmall),
            divider(),
            vspace(AppSpacing.small),

            // Canastillas
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Canastillas', style: tH2),
                pw.Text('${project.basketsQuantity}', style: tH2),
              ],
            ),

            vspace(AppSpacing.small),
            divider(),
            vspace(AppSpacing.small),

            // Gaveras en formato tabla
            pw.Text('Gaveras', style: tH2),
            vspace(AppSpacing.xSmall),

            if (project.gaveras.isEmpty)
              pw.Text('No hay gaveras registradas.', style: tBody)
            else
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey600,
                  width: 0.8,
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(3),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Cantidad', style: tEmph),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Peso referencia (g)', style: tEmph),
                      ),
                    ],
                  ),
                  ...project.gaveras.map(
                    (g) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${g.quantity}', style: tBody),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${g.referenceWeight}', style: tBody),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            vspace(AppSpacing.mediumSmall),
            divider(),
            vspace(AppSpacing.small),

            // Conservantes / Cal
            pw.Text('Materiales adicionales', style: tH2),
            vspace(AppSpacing.small),
            pw.Bullet(
              text:
                  'Conservantes: ${project.preservativesWeight} kg en ${project.preservativesJars} tarros',
              style: tBody,
            ),
            pw.Bullet(
              text:
                  'Cal: ${project.limeWeight} kg en ${project.limeJars} tarros',
              style: tBody,
            ),

            vspace(AppSpacing.medium),
          ],
        );
      },
    ),
  );

  // 5) Compartir
  final bytes = await pdf.save();
  await Printing.sharePdf(bytes: bytes, filename: 'proyecto_${project.id}.pdf');
}
