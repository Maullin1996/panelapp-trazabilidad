import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'qr_share.dart';

class MobileEntregaDetailPage extends ConsumerStatefulWidget {
  final String moliendaId;
  final String entregaId;
  const MobileEntregaDetailPage({
    required this.moliendaId,
    required this.entregaId,
    super.key,
  });

  @override
  ConsumerState<MobileEntregaDetailPage> createState() =>
      _MobileEntregaDetailPageState();
}

class _MobileEntregaDetailPageState
    extends ConsumerState<MobileEntregaDetailPage> {
  final GlobalKey _qrBoundaryKey = GlobalKey();

  Future<void> _shareQr(String moliendaNombre) async {
    final boundary =
        _qrBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final bytes = byteData.buffer.asUint8List();
    final fileName = 'qr_${_slugify(moliendaNombre)}_${widget.entregaId}.png';

    await shareOrDownloadQrPng(bytes, fileName);
  }

  String _slugify(String value) {
    final cleaned = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return cleaned.isEmpty ? 'molienda' : cleaned;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final entregasAsync = ref.watch(
      moliendaEntregasProvider(widget.moliendaId),
    );
    final moliendas = ref.watch(syncMoliendaItemsProvider);
    final moliendaNombre =
        moliendas.firstWhereOrNull((m) => m.id == widget.moliendaId)?.nombre ??
        'molienda';

    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      appBar: AppBar(
        title: Text('Detalle de entrega', style: textTheme.headlineMedium),
      ),
      body: entregasAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryPanelaBrown,
          ),
        ),
        error: (e, _) => ErrorWidgetCustom(error: e.toString()),
        data: (entregas) {
          final entrega = entregas.firstWhereOrNull(
            (e) => e.id == widget.entregaId,
          );
          if (entrega == null) {
            return Center(
              child: Text(
                'Entrega no encontrada',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textDark.withAlpha(120),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RepaintBoundary(
                      key: _qrBoundaryKey,
                      child: QrImageView(
                        data: entrega.qrToken,
                        size: 200,
                        backgroundColor: AppColors.cardBackground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      'Fecha de entrega',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textDark.withAlpha(150),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(entrega.fechaEntrega),
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _shareQr(moliendaNombre),
                        icon: const Icon(
                          Icons.share_outlined,
                          color: AppColors.textLight,
                          size: 18,
                        ),
                        label: Text(
                          'Compartir QR',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushNamed(
                          'loteDetail',
                          pathParameters: {
                            'produccionId': entrega.produccionId,
                          },
                        ),
                        icon: const Icon(
                          Icons.visibility_outlined,
                          color: AppColors.cardBackground,
                          size: 18,
                        ),
                        label: Text(
                          'Ver lote',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.cardBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
