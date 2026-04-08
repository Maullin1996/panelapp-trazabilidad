import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage5_summary/domain/stage5_summary_item.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_global_summary_provider.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_summary_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class Stage5Summary extends ConsumerWidget {
  final String projectId;
  const Stage5Summary({required this.projectId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryByDay = ref.watch(stage5SummaryProvider(projectId));
    final globalSummary = ref.watch(stage5GlobalSummaryProvider(projectId));
    final textTheme = TextTheme.of(context);

    if (summaryByDay.isEmpty) {
      return Center(
        child: Text('No ha habido cargues', style: textTheme.headlineMedium),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smallLarge,
        vertical: AppSpacing.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GlobalSummaryCard(globalSummary: globalSummary),
          const SizedBox(height: AppSpacing.smallLarge),
          Text(
            'Resumen diario',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.secondaryDarkPanela,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          ...summaryByDay.map((day) => _DaySummaryCard(day: day)),
        ],
      ),
    );
  }
}

// ── Tarjeta resumen global ──────────────────────────────────────────────────

class _GlobalSummaryCard extends StatelessWidget {
  final List<Stage5SummaryItem> globalSummary;
  const _GlobalSummaryCard({required this.globalSummary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryPanelaBrown,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      padding: const EdgeInsets.all(AppSpacing.smallLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total acumulado',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.accentLightPanela,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          ...globalSummary.map((it) => _GlobalSummaryRow(item: it)),
        ],
      ),
    );
  }
}

class _GlobalSummaryRow extends StatelessWidget {
  final Stage5SummaryItem item;
  const _GlobalSummaryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cantidad
          Text(
            '${item.totalCount}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(width: AppSpacing.xSmall),
          Text(
            'canastillas',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.accentLightPanela.withValues(alpha: 0.8),
            ),
          ),
          const Spacer(),
          // Badges
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Pill(
                label: '${item.realWeight.toStringAsFixed(0)} kg',
                background: AppColors.accentLightPanela.withValues(alpha: 0.2),
                textColor: AppColors.accentLightPanela,
              ),
              const SizedBox(height: 4),
              _Pill(
                label: 'gavera ${item.gaveraWeight.toStringAsFixed(0)} g',
                background: AppColors.textLight.withValues(alpha: 0.1),
                textColor: AppColors.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta día ─────────────────────────────────────────────────────────────

class _DaySummaryCard extends StatelessWidget {
  final Stage5SummaryDay day;
  const _DaySummaryCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat("EEEE d 'de' MMMM", 'es').format(day.date);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.primaryPanelaBrown.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Header fecha
          Container(
            width: double.infinity,
            color: AppColors.secondaryDarkPanela,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.smallLarge,
              vertical: AppSpacing.xSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentLightPanela,
                  ),
                ),
                Text(
                  '${day.items.length} ${day.items.length == 1 ? 'registro' : 'registros'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accentLightPanela.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...day.items.map(
            (e) => _DayItem(item: e, isLast: e == day.items.last),
          ),
        ],
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final Stage5SummaryItem item;
  final bool isLast;
  const _DayItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smallLarge,
            vertical: AppSpacing.small,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.totalCount}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'canastillas',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryDarkPanela.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Pill(
                    label: '${item.realWeight.toStringAsFixed(0)} kg',
                    background: AppColors.primaryPanelaBrown.withValues(
                      alpha: 0.12,
                    ),
                    textColor: AppColors.secondaryDarkPanela,
                  ),
                  const SizedBox(height: 4),
                  _Pill(
                    label: 'gavera ${item.gaveraWeight.toStringAsFixed(0)} g',
                    background: AppColors.primaryPanelaBrown.withValues(
                      alpha: 0.07,
                    ),
                    textColor: AppColors.primaryPanelaBrown,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.primaryPanelaBrown.withValues(alpha: 0.1),
            indent: AppSpacing.smallLarge,
            endIndent: AppSpacing.smallLarge,
          ),
      ],
    );
  }
}

// ── Widget reutilizable Pill ─────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;
  const _Pill({
    required this.label,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
