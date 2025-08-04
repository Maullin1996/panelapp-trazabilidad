import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage5_2_records/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
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
        .firstWhere((r) => r.id == recordId);

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detalle del registro', style: textTheme.headlineLarge),
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
            CustomRichText(
              icon: Icons.calendar_month,
              firstText: 'Fecha: ',
              secondText: DateFormat.yMd().format(record.date),
            ),
            const SizedBox(height: AppSpacing.small),
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
              secondText: '${record.panelaWeight.toStringAsFixed(2)} kg',
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
    );
  }
}
