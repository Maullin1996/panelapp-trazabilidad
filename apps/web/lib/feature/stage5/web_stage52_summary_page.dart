import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/features/stage5_2_records/providers/sync_stage52_loads_provider.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import '../shared/web_layout.dart';

class WebStage52SummaryPage extends ConsumerWidget {
  final String projectId;
  final String recordId;
  const WebStage52SummaryPage({
    super.key,
    required this.projectId,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref
        .watch(syncStage52LoadsProvider)
        .firstWhereOrNull((r) => r.id == recordId);

    final textTheme = TextTheme.of(context);

    if (record == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WebLayout(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.secondaryDarkPanela.withAlpha(30),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Text(
                  'Detalle del registro'.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
              ],
            ),
          ),

          // ── Contenido centrado ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (record.photoPath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          child: StageImageWidget(
                            imageUrl: record.photoPath,
                            width: double.infinity,
                            height: 600,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.medium),
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: AppSpacing.small,
                                right: AppSpacing.small,
                                top: AppSpacing.xSmall,
                              ),
                              child: Text(
                                DateFormat.yMd().format(record.date),
                                style: textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primaryPanelaBrown,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                color: AppColors.secondaryDarkPanela.withAlpha(
                                  45,
                                ),
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
                                    firstText: 'Unidades de panela: ',
                                    secondText: record.unitCount.toString(),
                                  ),
                                  const SizedBox(height: AppSpacing.small),
                                  CustomRichText(
                                    icon: Icons.verified,
                                    iconColor: AppColors.accepted,
                                    firstText: 'Calidad: ',
                                    secondText: record.quality.name
                                        .toUpperCase(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
