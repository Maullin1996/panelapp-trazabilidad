import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/services/custom_snack_bar.dart';
import 'package:core/features/auth/domain/enums/user_role.dart';
import 'package:core/features/auth/providers/auth_provider.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import 'package:core/shared/utils/tokens.dart';

import 'package:core/shared/widgets/widgets.dart';

class Stage2Page extends ConsumerWidget {
  final String projectId;
  const Stage2Page({super.key, required this.projectId});

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

    final error = ref.watch(stage2LoadsErrorProvider);

    final loads = ref
        .watch(syncStage2ProjectsProvider)
        .where((l) => l.projectId == projectId)
        .toList();

    final isLoading = ref.watch(stage2ProjectsLoadingProvider);

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final textTheme = TextTheme.of(context);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cargues ${project.name}'.toUpperCase(),
          style: textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        bottom: true,
        child: isLoading && loads.isEmpty
            ? const Stage2Shimmer(itemCount: 5)
            : loads.isEmpty
            ? const EmptyWidget()
            : (error != null)
            ? ErrorWidgetCustom(error: error)
            : ListView.separated(
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.small),
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.medium,
                  left: AppSpacing.small,
                  right: AppSpacing.small,
                  top: AppSpacing.small,
                ),
                itemCount: loads.length,
                itemBuilder: (BuildContext context, int index) {
                  final load = loads[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dctx) => AlertDialog(
                          backgroundColor: AppColors.cardBackground,
                          title: Text(
                            '¿Qué deseas hacer?',
                            style: textTheme.headlineMedium,
                          ),
                          actions: [
                            Column(
                              children: [
                                SelectionSourceTile(
                                  key: Key('stage2-page-edit-textbutton'),
                                  icon: Icons.edit_outlined,
                                  label: "Editar",
                                  onTap: () {
                                    Navigator.pop(dctx);
                                    showModalBottomSheet(
                                      backgroundColor: AppColors.cardBackground,
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (_) => Padding(
                                        padding: MediaQuery.viewInsetsOf(
                                          context,
                                        ),
                                        child: Stage2LoadForm(
                                          project: project,
                                          initialData: load,
                                          isNew: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: AppSpacing.xSmall),
                                SelectionSourceTile(
                                  icon: Icons.cancel_outlined,
                                  label: 'Cancelar',
                                  onTap: () => Navigator.pop(dctx),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    child: Dismissible(
                      key: Key('stage2-page-load-dismissible-${load.id}'),
                      direction: user != null && user.role == UserRole.admin
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.cardBackground,
                                title: Text(
                                  '¿Eliminar proyecto?',
                                  style: textTheme.headlineLarge,
                                ),
                                content: Text(
                                  'Esta acción no se puede deshacer.',
                                  style: textTheme.bodyLarge,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(
                                      'Cancelar',
                                      style: textTheme.bodyLarge,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
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
                        await ref.read(deleteStage2DataProvider).call(load.id);
                      },
                      background: DismissbleBackgraoundContainer(),
                      child: CustomCard(
                        key: Key('stage2-page-load-custom-card-${load.id}'),
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
                                    icon: Icons.unarchive,
                                    iconColor: AppColors.alert,
                                    size: 20,
                                  ),
                                  SizedBox(width: AppSpacing.xSmall),
                                  Expanded(
                                    child: Text(
                                      DateFormat.yMd().format(load.date),
                                      style: textTheme.headlineMedium?.copyWith(
                                        color: AppColors.secondaryDarkPanela,
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
                                    icon: Icons.shopping_basket,
                                    iconColor: AppColors.register,
                                    size: 15,
                                    firstText: 'Canastillas: ',
                                    secondText: load.baskets.count.toString(),
                                  ),

                                  const SizedBox(height: AppSpacing.xSmall),
                                  CustomRichText(
                                    key: Key(
                                      'stage2_page_${load.baskets.quality.name}-quality',
                                    ),
                                    icon: Icons.verified,
                                    iconColor: AppColors.accepted,
                                    size: 15,
                                    firstText: 'Calidad: ',
                                    secondText: load.baskets.quality.label,
                                  ),

                                  const SizedBox(height: AppSpacing.xSmall),
                                  CustomRichText(
                                    icon: Icons.storage_outlined,
                                    iconColor: AppColors.weight,
                                    size: 15,
                                    firstText: 'Gavera: ',
                                    secondText:
                                        '${load.baskets.referenceWeight} g',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.smallLarge,
            AppSpacing.xSmall,
            AppSpacing.smallLarge,
            AppSpacing.small,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              key: const Key('stage2-page-create-load-button'),
              onPressed: () => showStage2LoadModal(context, project),
              icon: const Icon(
                Icons.add_rounded,
                color: AppColors.cardBackground,
                size: 22,
              ),
              label: Text(
                'Nuevo cargue',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.cardBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
