import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_usecases_provider.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';

class Stage52Page extends ConsumerWidget {
  final String projectId;
  const Stage52Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(stage52ByProjectProvider(projectId));
    final textTheme = TextTheme.of(context);

    if (records.isEmpty) {
      return Scaffold(
        body: const EmptyWidget(),
        floatingActionButton: _NewRecordFab(projectId: projectId),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }

    final totalUnits = records.fold(0, (s, r) => s + r.unitCount);
    final totalKg = records.fold(0.0, (s, r) => s + r.panelaWeight);

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xSmall,
          AppSpacing.xSmall,
          AppSpacing.xSmall,
          100,
        ),
        itemCount: records.length + 1, // +1 para la barra de resumen
        itemBuilder: (_, i) {
          // Primer ítem: barra de resumen
          if (i == 0) {
            return _SummaryBar(
              recordCount: records.length,
              totalUnits: totalUnits,
              totalKg: totalKg,
            );
          }

          final r = records[i - 1];
          final user = ref.read(authProvider).user;

          return Dismissible(
            key: Key('data-selector-dismissible-${r.id}'),
            direction: user != null && user.role == UserRole.admin
                ? DismissDirection.endToStart
                : DismissDirection.none,
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.cardBackground,
                      title: Text(
                        '¿Eliminar registro?',
                        style: textTheme.headlineLarge,
                      ),
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
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
            onDismissed: (_) async {
              await ref.read(deleteStage52DataProvider).call(r.id);
            },
            background: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xSmall),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.smallLarge),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            child: _RecordCard(
              record: r,
              onTap: () => showDialog(
                context: context,
                builder: (_) =>
                    _RecordActionDialog(projectId: projectId, recordId: r.id),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _NewRecordFab(projectId: projectId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ─── Barra de resumen ────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  final int recordCount;
  final int totalUnits;
  final double totalKg;

  const _SummaryBar({
    required this.recordCount,
    required this.totalUnits,
    required this.totalKg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
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
          _SummaryItem(value: '$recordCount', label: 'Registros'),
          _SummaryDivider(),
          _SummaryItem(value: '$totalUnits', label: 'Unidades'),
          _SummaryDivider(),
          _SummaryItem(
            value: '${totalKg.toStringAsFixed(1)} kg',
            label: 'Total gavera',
          ),
        ],
      ),
    );
  }
}

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

// ─── Tarjeta de registro ─────────────────────────────────────────────────────

class _RecordCard extends StatelessWidget {
  final Stage52RecordData record; // tu tipo Stage52Record
  final VoidCallback onTap;

  const _RecordCard({required this.record, required this.onTap});

  Color get _qualityColor {
    switch (record.quality.name) {
      case 'negra':
        return AppColors.textDark;
      case 'regular':
        return AppColors.alert;
      case 'buena':
        return AppColors.accepted;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = record;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.large),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
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
                          _QualityBadge(
                            label: r.quality.name.toUpperCase(),
                            color: _qualityColor,
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MetricChip(
                                icon: Icons.unarchive_outlined,
                                iconColor: AppColors.accepted,
                                label: 'Unidades',
                                value: '${r.unitCount}',
                              ),
                              _MetricChip(
                                icon: Icons.scale,
                                label: 'Gavera',
                                value: '${r.gaveraWeight.toStringAsFixed(0)}g',
                                iconColor: AppColors.register,
                              ),
                              _MetricChip(
                                icon: Icons.storage_outlined,
                                label: 'Paquete',
                                value:
                                    '${r.panelaWeight.toStringAsFixed(2)} kg',
                                iconColor: AppColors.weight,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Foto (si existe)
                  if (r.photoPath.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: StageImageWidget(
                          imagePath: r.photoPath,
                          width: 120,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
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

// ─── Badge de calidad ────────────────────────────────────────────────────────

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

// ─── Chip de métrica ─────────────────────────────────────────────────────────

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
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
          Container(
            padding: const EdgeInsets.all(AppSpacing.xSmall),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.textDark).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, size: 13, color: iconColor ?? AppColors.textDark),
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

// ─── FAB ─────────────────────────────────────────────────────────────────────

class _NewRecordFab extends StatelessWidget {
  final String projectId;
  const _NewRecordFab({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xSmall),
      child: SizedBox(
        width: double.infinity,
        child: FloatingActionButton.extended(
          key: const Key('stage52-page-form-button'),
          onPressed: () {
            context.push('${Routes.stage5}/$projectId/records/form');
          },
          backgroundColor: AppColors.primaryPanelaBrown,
          foregroundColor: AppColors.textLight,
          icon: const Icon(Icons.add),
          label: Text(
            'Nuevo registro',
            style: TextTheme.of(
              context,
            ).headlineSmall?.copyWith(color: AppColors.textLight),
          ),
        ),
      ),
    );
  }
}

// ─── Dialog de acciones ───────────────────────────────────────────────────────

class _RecordActionDialog extends StatelessWidget {
  final String projectId;
  final String recordId;
  const _RecordActionDialog({required this.projectId, required this.recordId});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return AlertDialog(
      backgroundColor: AppColors.backgroundCrema,
      title: Center(
        child: Text('¿Qué quieres hacer?', style: textTheme.headlineMedium),
      ),
      actions: [
        _ActionTile(
          icon: Icons.article_outlined,
          label: 'Ver resumen',
          onTap: () {
            context.pop();
            context.push(
              '${Routes.stage5}/$projectId/records/$recordId/summary',
            );
          },
        ),
        const SizedBox(height: 8),
        _ActionTile(
          icon: Icons.edit_outlined,
          label: 'Editar registro',
          onTap: () {
            context.pop();
            context.push('${Routes.stage5}/$projectId/records/$recordId/edit');
          },
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.textDark),
        title: Text(label, style: TextTheme.of(context).headlineSmall),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textDark,
          size: 20,
        ),
      ),
    );
  }
}
