import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/services/custom_snack_bar.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import 'package:core/features/stage3_weigh/providers/stage3_form_provider.dart';
import 'package:core/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:core/shared/utils/tokens.dart';
import '../stage3/web_stage3_load_form.dart';
import '../shared/web_layout.dart';

class WebStage3FormPage extends ConsumerWidget {
  final String projectId;
  final String load2Id;

  const WebStage3FormPage({
    required this.projectId,
    required this.load2Id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(stage1ProjectByIdProvider(projectId));
    final load2 = ref
        .watch(syncStage2ProjectsProvider)
        .firstWhereOrNull((l) => l.id == load2Id);
    final initialData = ref
        .watch(syncStage3ProjectsProvider)
        .firstWhereOrNull(
          (e) => e.projectId == projectId && e.stage2LoadId == load2Id,
        );
    final isNew = initialData == null;
    final textTheme = TextTheme.of(context);

    ref.listen<Stage3FormState>(stage3FormProvider, (previous, next) {
      if (previous?.status == Stage3FormStatus.submitting &&
          next.status == Stage3FormStatus.success) {
        context.pop();
        CustomSnackBar.show(
          context,
          message: 'Pesajes guardados',
          status: SnackbarStatus.accepted,
        );
      }
      if (next.status == Stage3FormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al guardar',
          status: SnackbarStatus.error,
        );
      }
    });

    if (project == null || load2 == null) {
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
                  isNew
                      ? 'Registrar pesaje'.toUpperCase()
                      : 'Editar pesaje'.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
              ],
            ),
          ),

          // ── Formulario centrado ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: WebStage3LoadForm(
                    project: project,
                    load2: load2,
                    isNew: isNew,
                    initialData: initialData,
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
