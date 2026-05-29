import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/services/custom_snack_bar.dart';
import 'package:core/features/auth/domain/enums/user_role.dart';
import 'package:core/features/auth/providers/auth_provider.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import '../shared/web_layout.dart';
import 'package:core/features/stage2_load/domain/entities/index.dart';

class WebStage2Page extends ConsumerWidget {
  final String projectId;
  const WebStage2Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(stage2FormProvider, (previous, next) {
      if (previous?.status == Stage2FormStatus.submitting &&
          next.status == Stage2FormStatus.success) {
        CustomSnackBar.show(
          context,
          message: 'Cargue registrado',
          status: SnackbarStatus.accepted,
        );
      }
      if (next.status == Stage2FormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al guardar',
          status: SnackbarStatus.error,
        );
      }
    });

    final project = ref.watch(stage1ProjectByIdProvider(projectId));
    final loads = ref
        .watch(syncStage2ProjectsProvider)
        .where((l) => l.projectId == projectId)
        .toList();
    final isLoading = ref.watch(stage2ProjectsLoadingProvider);
    final error = ref.watch(stage2LoadsErrorProvider);
    final user = ref.watch(authProvider).user;
    final textTheme = TextTheme.of(context);

    if (project == null) {
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
                  'Cargues ${project.name}'.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showFormDialog(context, ref, project),
                  icon: const Icon(Icons.add, color: AppColors.cardBackground),
                  label: Text(
                    'Nuevo cargue',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.cardBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Contenido ─────────────────────────────────────────
          Expanded(
            child: isLoading && loads.isEmpty
                ? const Stage2Shimmer(itemCount: 5)
                : error != null
                ? ErrorWidgetCustom(error: error)
                : loads.isEmpty
                ? const EmptyWidget()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.medium),
                          itemCount: loads.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.small),
                          itemBuilder: (_, index) {
                            final load = loads[index];
                            return _LoadCard(
                              load: load,
                              project: project,
                              onEdit: () => _showFormDialog(
                                context,
                                ref,
                                project,
                                initialData: load,
                                isNew: false,
                              ),
                              onDelete: user?.role == UserRole.admin
                                  ? () => _confirmDelete(
                                      context,
                                      ref,
                                      load.id,
                                      textTheme,
                                    )
                                  : null,
                            );
                          },
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomCard(
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                AppColors.primaryPanelaBrown.withAlpha(15),
                              ),
                              columns: const [
                                DataColumn(label: Text('Fecha')),
                                DataColumn(label: Text('Canastillas')),
                                DataColumn(label: Text('Calidad')),
                                DataColumn(label: Text('Gavera (g)')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: loads.map((load) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        DateFormat.yMd().format(load.date),
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        load.baskets.count.toString(),
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        load.baskets.quality.label,
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${load.baskets.referenceWeight} g',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              color:
                                                  AppColors.primaryPanelaBrown,
                                            ),
                                            onPressed: () => _showFormDialog(
                                              context,
                                              ref,
                                              project,
                                              initialData: load,
                                              isNew: false,
                                            ),
                                          ),
                                          if (user?.role == UserRole.admin)
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: AppColors.error,
                                              ),
                                              onPressed: () => _confirmDelete(
                                                context,
                                                ref,
                                                load.id,
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
      ),
    );
  }

  void _showFormDialog(
    BuildContext context,
    WidgetRef ref,
    project, {
    initialData,
    bool isNew = true,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Stage2LoadForm(
              project: project,
              initialData: initialData,
              isNew: isNew,
            ),
          ),
        ),
      ),
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
        title: Text('¿Eliminar cargue?', style: textTheme.headlineLarge),
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
      await ref.read(deleteStage2DataProvider).call(id);
    }
  }
}

class _LoadCard extends StatelessWidget {
  final Stage2LoadData load;
  final dynamic project;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _LoadCard({
    required this.load,
    required this.project,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: Icons.unarchive,
                  iconColor: AppColors.alert,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    DateFormat.yMd().format(load.date),
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondaryDarkPanela,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryPanelaBrown,
                  ),
                  onPressed: onEdit,
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
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

          // ── Datos ──
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.small,
            ),
            child: Column(
              children: [
                CustomRichText(
                  icon: Icons.shopping_basket,
                  iconColor: AppColors.register,
                  firstText: 'Canastillas: ',
                  secondText: load.baskets.count.toString(),
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.verified,
                  iconColor: AppColors.accepted,
                  firstText: 'Calidad: ',
                  secondText: load.baskets.quality.label,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.storage_outlined,
                  iconColor: AppColors.weight,
                  firstText: 'Gavera: ',
                  secondText: '${load.baskets.referenceWeight} g',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
