import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class MobileEntregaDetailPage extends ConsumerWidget {
  final String moliendaId;
  final String entregaId;
  const MobileEntregaDetailPage({
    required this.moliendaId,
    required this.entregaId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final entregasAsync = ref.watch(moliendaEntregasProvider(moliendaId));

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
          final entrega = entregas.firstWhereOrNull((e) => e.id == entregaId);
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
                    QrImageView(
                      data: entrega.qrToken,
                      size: 200,
                      backgroundColor: AppColors.cardBackground,
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
