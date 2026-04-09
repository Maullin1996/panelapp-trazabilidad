import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';

class Stage52SummaryPage extends ConsumerWidget {
  final String projectId;
  final String recordId;
  const Stage52SummaryPage({
    super.key,
    required this.projectId,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref
        .watch(syncStage52LoadsProvider)
        .firstWhereOrNull((r) => r.id == recordId);

    if (record == null) {
      return const Scaffold(
        body: Center(child: Text('Registro no encontrado')),
      );
    }

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detalle del registro', style: textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.small,
          AppSpacing.small,
          AppSpacing.small,
          AppSpacing.large,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (record.photoPath.isNotEmpty)
              StageImageWidget(
                imagePath: record.photoPath,
                fit: BoxFit.contain,
              ),
            const SizedBox(height: AppSpacing.smallLarge),
            CustomCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryDarkPanela,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.smallLarge),
                        topRight: Radius.circular(AppSpacing.smallLarge),
                      ),
                    ),
                    child: CustomRichText(
                      icon: Icons.calendar_month,
                      iconColor: AppColors.backgroundCrema,
                      firstTextColor: AppColors.backgroundCrema,
                      secondTextColor: AppColors.backgroundCrema,
                      firstText: 'Fecha: ',
                      secondText: DateFormat.yMd().format(record.date),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xSmall),
                    child: Column(
                      children: [
                        CustomRichText(
                          icon: Icons.storage_outlined,
                          iconColor: AppColors.weight,
                          firstText: 'Gavera usada: ',
                          secondText: '${record.gaveraWeight} g',
                        ),
                        const SizedBox(height: AppSpacing.small),
                        CustomRichText(
                          icon: Icons.scale,
                          iconColor: AppColors.weight,
                          firstText: 'Peso panela: ',
                          secondText:
                              '${record.panelaWeight.toStringAsFixed(2)} kg',
                        ),
                        const SizedBox(height: AppSpacing.small),
                        CustomRichText(
                          icon: Icons.unarchive_outlined,
                          firstText: 'Unidades  de panela: ',
                          secondText: record.unitCount.toString(),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        CustomRichText(
                          icon: Icons.verified,
                          iconColor: AppColors.accepted,
                          firstText: 'Calidad: ',
                          secondText: record.quality.name.toUpperCase(),
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
    );
  }
}
