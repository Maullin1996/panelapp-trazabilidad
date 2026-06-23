import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/providers/index.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class WebLoteDetailPage extends ConsumerWidget {
  final String produccionId;
  const WebLoteDetailPage({required this.produccionId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final stage1Async = ref.watch(
      stage1ProjectByIdRemoteProvider(produccionId),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      appBar: AppBar(
        title: Text('Detalle de lote', style: textTheme.headlineMedium),
      ),
      body: stage1Async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryPanelaBrown,
          ),
        ),
        error: (e, _) => ErrorWidgetCustom(error: e.toString()),
        data: (data) {
          if (data == null) {
            return Center(
              child: Text(
                'Lote no encontrado',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textDark.withAlpha(120),
                ),
              ),
            );
          }
          return _LoteDetailBody(data: data, textTheme: textTheme);
        },
      ),
    );
  }
}

class _LoteDetailBody extends ConsumerWidget {
  final Stage1FormData data;
  final TextTheme textTheme;
  const _LoteDetailBody({required this.data, required this.textTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moliendaId = data.moliendaId;

    DateTime fechaEntrega = data.date;
    if (moliendaId != null) {
      final entregasAsync = ref.watch(moliendaEntregasProvider(moliendaId));
      final entrega = entregasAsync.maybeWhen(
        data: (entregas) =>
            entregas.firstWhereOrNull((e) => e.produccionId == data.id),
        orElse: () => null,
      );
      if (entrega != null) fechaEntrega = entrega.fechaEntrega;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Molienda',
                    value: data.name,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _InfoRow(
                    label: 'Fecha de entrega',
                    value: DateFormat('dd/MM/yyyy HH:mm').format(
                      fechaEntrega,
                    ),
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _InfoRow(
                    label: 'Teléfono',
                    value: data.phone,
                    textTheme: textTheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textDark.withAlpha(150),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: textTheme.bodyLarge),
      ],
    );
  }
}
