import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/pdf/helpers/generate_and_share_pdf.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

// Mapea tus tamaños a puntos del PDF (un poco más grandes para impresión)
class PdfTypography {
  static const double body = AppTypography.body; // 18
  static const double h5 = 14; // ↑ desde 12
  static const double h4 = 18; // ↑ desde 16
  static const double h3 = 22; // ↑ desde 20
  static const double h2 = 28; // ↑ desde 24
  static const double h1 = 34; // ↑ desde 30
}

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key, required this.project});

  final Stage1FormData project;

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  Future<Uint8List>? _pdfFuture;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    setState(() {
      _pdfFuture = _createPdfBytes();
    });
  }

  Future<Uint8List> _createPdfBytes() async {
    // Usamos la lógica existente pero modificada para retornar bytes
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

    final tH1 = pw.TextStyle(font: fontBold, fontSize: PdfTypography.h1);
    final tH2 = pw.TextStyle(font: fontBold, fontSize: PdfTypography.h2);
    final tH3 = pw.TextStyle(font: fontBold, fontSize: PdfTypography.h3);
    final tBody = pw.TextStyle(font: fontRegular, fontSize: PdfTypography.body);
    final tEmph = pw.TextStyle(font: fontBold, fontSize: PdfTypography.body);

    pw.Widget vspace(double h) => pw.SizedBox(height: h);
    pw.Widget divider() => pw.Divider(thickness: 1);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Recursos suministrados', style: tH1),
              vspace(AppSpacing.smallLarge),

              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(width: 1, color: PdfColors.grey600),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Nombre: ${widget.project.name}', style: tH3),
                    vspace(AppSpacing.xSmall),
                    pw.Text(
                      'Fecha: ${DateFormat.yMd().format(widget.project.date)}',
                      style: tBody,
                    ),
                    vspace(AppSpacing.xSmall),
                    pw.Text('Teléfono: ${widget.project.phone}', style: tBody),
                  ],
                ),
              ),

              vspace(AppSpacing.mediumSmall),
              divider(),
              vspace(AppSpacing.small),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Canastillas', style: tH2),
                  pw.Text('${widget.project.basketsQuantity}', style: tH2),
                ],
              ),

              vspace(AppSpacing.small),
              divider(),
              vspace(AppSpacing.small),

              pw.Text('Gaveras', style: tH2),
              vspace(AppSpacing.xSmall),

              if (widget.project.gaveras.isEmpty)
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
                    ...widget.project.gaveras.map(
                      (g) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${g.quantity}', style: tBody),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '${g.referenceWeight}',
                              style: tBody,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              vspace(AppSpacing.mediumSmall),
              divider(),
              vspace(AppSpacing.small),

              pw.Text('Materiales adicionales', style: tH2),
              vspace(AppSpacing.small),
              pw.Bullet(
                text:
                    'Conservantes: ${widget.project.preservativesWeight} kg en ${widget.project.preservativesJars} tarros',
                style: tBody,
              ),
              pw.Bullet(
                text:
                    'Cal: ${widget.project.limeWeight} kg en ${widget.project.limeJars} tarros',
                style: tBody,
              ),

              vspace(AppSpacing.medium),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundCrema,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Vista previa del PDF',
          style: textTheme.headlineLarge?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.register),
            onPressed: () async {
              await generateAndSharePdf(widget.project);
            },
            tooltip: 'Compartir PDF',
          ),
        ],
      ),
      body: FutureBuilder<Uint8List>(
        future: _pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.register,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Generando PDF...',
                    style: TextStyle(color: AppColors.textDark, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.smallLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Error al generar el PDF',
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generatePdf,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.register,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No se pudo generar el PDF'));
          }

          return Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.small),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PdfPreview(
                      build: (format) => snapshot.data!,
                      allowPrinting: false,
                      allowSharing: false,
                      canChangeOrientation: false,
                      canChangePageFormat: false,
                      canDebug: false,
                      scrollViewDecoration: const BoxDecoration(),
                      pdfPreviewPageDecoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      loadingWidget: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.register,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.smallLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Printing.layoutPdf(
                              onLayout: (format) async => snapshot.data!,
                            );
                          },
                          icon: const Icon(Icons.print),
                          label: const Text('Imprimir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.weight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await generateAndSharePdf(widget.project);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Compartir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.register,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
