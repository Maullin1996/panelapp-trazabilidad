import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/auth/domain/enums/user_role.dart';
import 'package:core/features/auth/providers/auth_provider.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:core/features/stage5_2_records/providers/providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class WebStage52Page extends ConsumerWidget {
  final String projectId;
  const WebStage52Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(stage52ByProjectProvider(projectId));
    final summary = ref.watch(stage52SummaryProvider(projectId));
    final user = ref.watch(authProvider).user;
    final isLoading = ref.watch(stage52LoadingProvider);
    final textTheme = TextTheme.of(context);

    if (isLoading && records.isEmpty) {
      return const Stage52Shimmer(itemCount: 6);
    }

    return Column(
      children: [
        // ── Barra de resumen ──────────────────────────────────
        Container(
          margin: const EdgeInsets.all(AppSpacing.medium),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: AppColors.primaryPanelaBrown.withValues(alpha: 0.18),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              _SummaryItem(value: '${summary.count}', label: 'Registros'),
              _SummaryDivider(),
              _SummaryItem(value: '${summary.units}', label: 'Unidades'),
              _SummaryDivider(),
              _SummaryItem(
                value: '${summary.kg.toStringAsFixed(1)} kg',
                label: 'Total gavera',
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.medium),
                child: ElevatedButton.icon(
                  onPressed: () => context.push(
                    '${Routes.stage5}/$projectId/records/form',
                  ),
                  icon: const Icon(Icons.add, color: AppColors.cardBackground),
                  label: Text(
                    'Nuevo registro',
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

        // ── Grid de registros ─────────────────────────────────
        Expanded(
          child: records.isEmpty
              ? const EmptyWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.medium,
                    0,
                    AppSpacing.medium,
                    AppSpacing.medium,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final cols = w < 650 ? 1 : w < 1000 ? 2 : w < 1350 ? 3 : 4;
                      final cardWidth =
                          (w - AppSpacing.medium * (cols - 1)) / cols;
                      return Wrap(
                        alignment: WrapAlignment.start,
                        spacing: AppSpacing.medium,
                        runSpacing: AppSpacing.medium,
                        children: records.map((r) {
                          return SizedBox(
                            width: cardWidth,
                            child: _RecordCard(
                              record: r,
                              onViewSummary: () => context.push(
                                '${Routes.stage5}/$projectId/records/${r.id}/summary',
                              ),
                              onEdit: () => context.push(
                                '${Routes.stage5}/$projectId/records/${r.id}/edit',
                              ),
                              onDelete: user?.role == UserRole.admin
                                  ? () => _confirmDelete(
                                      context,
                                      ref,
                                      r.id,
                                      textTheme,
                                    )
                                  : null,
                              onPhotoTap: r.photoPath.isNotEmpty
                                  ? () => context.push(
                                      Routes.imageViewer,
                                      extra: r.photoPath,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    TextTheme textTheme,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('¿Eliminar registro?', style: textTheme.headlineLarge),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: textTheme.bodyLarge),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(deleteStage52DataProvider).call(id);
    }
  }
}

// ─── Barra de resumen ─────────────────────────────────────────────────────────

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  const _SummaryItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextTheme.of(context).headlineLarge?.copyWith(
              color: AppColors.primaryPanelaBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.secondaryDarkPanela,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 36,
      color: AppColors.textDark.withValues(alpha: 0.12),
    );
  }
}

// ─── Tarjeta de registro ──────────────────────────────────────────────────────

class _RecordCard extends StatelessWidget {
  final Stage52RecordData record;
  final VoidCallback onViewSummary;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPhotoTap;

  const _RecordCard({
    required this.record,
    required this.onViewSummary,
    required this.onEdit,
    this.onDelete,
    this.onPhotoTap,
  });

  Color get _qualityColor => switch (record.quality) {
    BasketQuality.negra => AppColors.textDark,
    BasketQuality.regular => AppColors.alert,
    BasketQuality.buena => AppColors.accepted,
    BasketQuality.extra => AppColors.error,
  };

  @override
  Widget build(BuildContext context) {
    final r = record;
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(AppRadius.large),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textDark.withValues(alpha: 0.08),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Acento lateral de calidad
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _qualityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.large),
                    bottomLeft: Radius.circular(AppRadius.large),
                  ),
                ),
              ),
              // Contenido
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header: badge + acciones ──
                      Row(
                        children: [
                          _QualityBadge(
                            label: r.quality.name.toUpperCase(),
                            color: _qualityColor,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.article_outlined,
                              color: AppColors.register,
                            ),
                            tooltip: 'Ver resumen',
                            onPressed: onViewSummary,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primaryPanelaBrown,
                            ),
                            tooltip: 'Editar',
                            onPressed: onEdit,
                          ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                              tooltip: 'Eliminar',
                              onPressed: onDelete,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // ── Métricas ──
                      _MetricChip(
                        icon: Icons.calendar_month,
                        label: 'Fecha',
                        value: DateFormat.yMd().format(r.date),
                        iconColor: AppColors.weight,
                      ),
                      _MetricChip(
                        icon: Icons.unarchive_outlined,
                        label: 'Unidades',
                        value: '${r.unitCount}',
                        iconColor: AppColors.accepted,
                      ),
                      _MetricChip(
                        icon: Icons.scale,
                        label: 'Gavera',
                        value: '${r.gaveraWeight.toStringAsFixed(0)} g',
                        iconColor: AppColors.register,
                      ),
                      _MetricChip(
                        icon: Icons.storage_outlined,
                        label: 'Paquete',
                        value: '${r.panelaWeight.toStringAsFixed(2)} kg',
                        iconColor: AppColors.weight,
                      ),
                    ],
                  ),
                ),
              ),
              // Foto
              if (r.photoPath.isNotEmpty)
                GestureDetector(
                  onTap: onPhotoTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: StageImageWidget(
                        imageUrl: r.photoPath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Badge de calidad ─────────────────────────────────────────────────────────

class _QualityBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _QualityBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ─── Chip de métrica ──────────────────────────────────────────────────────────

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xSmall),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconDecoration(
            icon: icon,
            iconColor: iconColor,
            backgroundColor: iconColor.withValues(alpha: 0.12),
          ),
          const SizedBox(width: 4),
          Text(
            '$label ',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: AppColors.secondaryDarkPanela,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
