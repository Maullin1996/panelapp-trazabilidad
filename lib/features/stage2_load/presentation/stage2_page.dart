import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/presentation/widgets/stage2_load_form.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';
import 'package:registro_panela/shared/widgets/dismissble_backgraound_container.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';
import 'package:registro_panela/shared/widgets/error_widget_custom.dart';

class Stage2Page extends ConsumerWidget {
  final String projectId;
  const Stage2Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(stage2FormProvider, (previous, next) {
      if (previous?.status == Stage2FormStatus.submitting &&
          next.status == Stage2FormStatus.success) {
        context.pop();
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
          status: SnackbarStatus.accepted,
        );
      }
    });
    final project = ref.watch(stage1ProjectByIdProvider(projectId));

    final error = ref.watch(stage2LoadsErrorProvider);

    final loads = ref
        .watch(syncStage2ProjectsProvider)
        .where((l) => l.projectId == projectId)
        .toList();

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cargues ${project.name}'.toUpperCase(),
          style: textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: loads.isEmpty
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
                final user = ref.read(authProvider).user;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dctx) => AlertDialog(
                        backgroundColor: AppColors.cardBackground,
                        title: Text(
                          '¿Editar este cargue?',
                          style: textTheme.headlineMedium,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dctx),
                            child: Text(
                              'Cancelar',
                              style: textTheme.headlineSmall,
                            ),
                          ),
                          TextButton(
                            key: Key('stage2-page-edit-textbutton'),
                            onPressed: () {
                              Navigator.pop(dctx);
                              showModalBottomSheet(
                                backgroundColor: AppColors.cardBackground,
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: Stage2LoadForm(
                                    project: project,
                                    initialData: load,
                                    isNew: false,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Editar',
                              style: textTheme.headlineSmall,
                            ),
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xSmall,
                              horizontal: AppSpacing.small,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryDarkPanela,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppRadius.medium),
                                topRight: Radius.circular(AppRadius.medium),
                              ),
                            ),
                            child: Text(
                              DateFormat.yMd().format(load.date),
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.small),
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
                                  key: Key(
                                    'stage2_page_${load.baskets.realWeight.toStringAsFixed(1)}-weight',
                                  ),
                                  icon: Icons.scale,
                                  iconColor: AppColors.weight,
                                  firstText: 'Peso: ',
                                  secondText:
                                      '${load.baskets.realWeight.toStringAsFixed(1)} kg',
                                ),

                                const SizedBox(height: AppSpacing.xSmall),
                                CustomRichText(
                                  icon: Icons.storage_outlined,
                                  iconColor: AppColors.weight,
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smallLarge),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              key: Key('stage2-page-create-load-button'),
              label: Text(
                'Nuevo cargue',
                style: textTheme.headlineLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(
                Icons.add_outlined,
                color: AppColors.textLight,
                size: 30,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.cardBackground,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: Stage2LoadForm(isNew: true, project: project),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
