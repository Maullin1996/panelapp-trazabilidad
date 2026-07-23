import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:registro_panela/features/molienda/presentation/providers/molienda_providers.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/index.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/helpers/quality_color.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

class MobileLoteDetailPage extends ConsumerWidget {
  final String produccionId;
  const MobileLoteDetailPage({required this.produccionId, super.key});

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
          child: CircularProgressIndicator(color: AppColors.primaryPanelaBrown),
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

    final loads2 = ref
        .watch(syncStage2ProjectsProvider)
        .where((l) => l.projectId == data.id)
        .toList();

    final stage3List = ref.watch(syncStage3ProjectsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconDecoration(
                        icon: Icons.note_alt_outlined,
                        iconColor: AppColors.register,
                        backgroundColor: AppColors.register,
                      ),
                      const SizedBox(width: AppSpacing.xSmall),
                      Expanded(
                        child: Text(
                          'Información del lote',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryPanelaBrown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.small,
                      vertical: AppSpacing.xSmall,
                    ),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.secondaryDarkPanela.withAlpha(45),
                    ),
                  ),
                  CustomRichText(
                    icon: Icons.factory_outlined,
                    iconColor: AppColors.secondaryDarkPanela,
                    firstText: 'Molienda: ',
                    secondText: data.name,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  CustomRichText(
                    icon: Icons.calendar_month,
                    iconColor: AppColors.weight,
                    firstText: 'Fecha de entrega: ',
                    secondText: DateFormat.yMd().format(fechaEntrega),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  CustomRichText(
                    icon: Icons.phone,
                    iconColor: AppColors.error,
                    firstText: 'Teléfono: ',
                    secondText: data.phone,
                  ),
                ],
              ),
            ),
          ),
          ...loads2.map((load2) {
            final entry3 = stage3List.firstWhereOrNull(
              (e) => e.stage2LoadId == load2.id,
            );
            if (entry3 == null) return const SizedBox.shrink();
            return Column(
              children: [
                const SizedBox(height: AppSpacing.small),
                _BodegaCard(load2: load2, entry3: entry3, textTheme: textTheme),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _BodegaCard extends StatelessWidget {
  final Stage2LoadData load2;
  final Stage3FormData entry3;
  final TextTheme textTheme;
  const _BodegaCard({
    required this.load2,
    required this.entry3,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: Icons.warehouse,
                  iconColor: AppColors.register,
                  backgroundColor: AppColors.register,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    'Registrado en Bodega',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryPanelaBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xSmall,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(45),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.small,
            ),
            child: Column(
              children: [
                CustomRichText(
                  icon: Icons.calendar_month,
                  firstText: 'Fecha pesaje: ',
                  secondText: DateFormat.yMd().format(entry3.date),
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.storage,
                  iconColor: AppColors.weight,
                  firstText: 'Gavera: ',
                  secondText: '${load2.baskets.referenceWeight} g',
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.all_inbox_rounded,
                  iconColor: AppColors.register,
                  firstText: 'Total registradas: ',
                  secondText: '${entry3.baskets.length} canastillas',
                ),
                const SizedBox(height: AppSpacing.xSmall),
                ...BasketQuality.values
                    .where((q) => entry3.baskets.any((b) => b.quality == q))
                    .map(
                      (q) => Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.small,
                          bottom: AppSpacing.xSmall,
                        ),
                        child: CustomRichText(
                          icon: Icons.circle,
                          backgroundDecoration: false,
                          iconColor: qualityColor(quality: q.label),
                          firstText: '${q.label}: ',
                          secondText:
                              '${entry3.baskets.where((b) => b.quality == q).length}',
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
