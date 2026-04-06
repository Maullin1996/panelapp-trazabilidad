import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/widget/stage3_load_form.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_form_provider.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class Stage3FormPage extends ConsumerWidget {
  final String projectId;
  final String load2Id;

  const Stage3FormPage({
    required this.projectId,
    required this.load2Id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(stage1ProjectByIdProvider(projectId));

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final load2 = ref
        .watch(syncStage2ProjectsProvider)
        .firstWhereOrNull((l) => l.id == load2Id);

    final initialData = ref
        .watch(syncStage3ProjectsProvider)
        .firstWhereOrNull(
          (e) => e.projectId == projectId && e.stage2LoadId == load2Id,
        );

    final isNew = initialData == null;

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
          message: "Error al guardar",
          status: SnackbarStatus.error,
        );
      }
    });

    final textTheme = TextTheme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isNew ? 'Registrar pesaje' : 'Editar pesaje',
            style: textTheme.headlineLarge,
          ),
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.small),
          child: Stage3LoadForm(
            project: project,
            load2: load2!,
            isNew: isNew,
            initialData: initialData,
          ),
        ),
      ),
    );
  }
}
