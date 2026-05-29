import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/auth/domain/enums/user_role.dart';
import 'package:core/features/auth/providers/auth_provider.dart';
import 'package:core/features/stage5_2_records/providers/providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'package:core/features/stage5_2_records/domain/entities/stage52_record_data.dart';

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
              color: AppColors.primaryPanelaBrown.withAlpha(25),
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
                  onPressed: () =>
                      context.push('${Routes.stage5}/$projectId/records/form'),
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

        // ── Tabla ────────────────────────────────────────────
        Expanded(
          child: records.isEmpty
              ? const EmptyWidget()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 1080) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                        ),
                        itemCount: records.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.small),
                        itemBuilder: (_, index) {
                          final r = records[index];
                          return _RecordCard(
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
                          );
                        },
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomCard(
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              AppColors.primaryPanelaBrown.withAlpha(15),
                            ),
                            columns: const [
                              DataColumn(label: Text('Fecha')),
                              DataColumn(label: Text('Gavera (g)')),
                              DataColumn(label: Text('Peso panela (kg)')),
                              DataColumn(label: Text('Unidades')),
                              DataColumn(label: Text('Calidad')),
                              DataColumn(label: Text('Foto')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: records.map((r) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      DateFormat.yMd().format(r.date),
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${r.gaveraWeight} g',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${r.panelaWeight.toStringAsFixed(2)} kg',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${r.unitCount}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      r.quality.name.toUpperCase(),
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    r.photoPath.isNotEmpty
                                        ? InkWell(
                                            onTap: () => context.push(
                                              Routes.imageViewer,
                                              extra: r.photoPath,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppRadius.small,
                                                    ),
                                                child: StageImageWidget(
                                                  imageUrl: r.photoPath,
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: AppColors.weight,
                                          ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.article_outlined,
                                            color: AppColors.register,
                                          ),
                                          tooltip: 'Ver resumen',
                                          onPressed: () => context.push(
                                            '${Routes.stage5}/$projectId/records/${r.id}/summary',
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            color: AppColors.primaryPanelaBrown,
                                          ),
                                          tooltip: 'Editar',
                                          onPressed: () => context.push(
                                            '${Routes.stage5}/$projectId/records/${r.id}/edit',
                                          ),
                                        ),
                                        if (user?.role == UserRole.admin)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: AppColors.error,
                                            ),
                                            tooltip: 'Eliminar',
                                            onPressed: () => _confirmDelete(
                                              context,
                                              ref,
                                              r.id,
                                              textTheme,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
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
      color: AppColors.textDark.withAlpha(12),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final Stage52RecordData record;
  final VoidCallback onViewSummary;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _RecordCard({
    required this.record,
    required this.onViewSummary,
    required this.onEdit,
    this.onDelete,
  });

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
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header con badge de calidad y acciones ──
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _qualityColor.withAlpha(33),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    r.quality.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _qualityColor,
                      letterSpacing: 0.4,
                    ),
                  ),
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
          ),

          // ── Divider ──
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

          // ── Datos + Foto ──
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.small,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRichText(
                        icon: Icons.calendar_month,
                        iconColor: AppColors.weight,
                        firstText: 'Fecha: ',
                        secondText: DateFormat.yMd().format(r.date),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.unarchive_outlined,
                        iconColor: AppColors.accepted,
                        firstText: 'Unidades: ',
                        secondText: '${r.unitCount}',
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.scale,
                        iconColor: AppColors.register,
                        firstText: 'Gavera: ',
                        secondText: '${r.gaveraWeight} g',
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.storage_outlined,
                        iconColor: AppColors.weight,
                        firstText: 'Panela: ',
                        secondText: '${r.panelaWeight.toStringAsFixed(2)} kg',
                      ),
                    ],
                  ),
                ),
                if (r.photoPath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.xSmall),
                    child: InkWell(
                      onTap: () =>
                          context.push(Routes.imageViewer, extra: r.photoPath),
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
        ],
      ),
    );
  }
}
