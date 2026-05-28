import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/services/custom_snack_bar.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import '../widgets/stage3_load_form.dart';
import 'package:core/features/stage3_weigh/providers/stage3_form_provider.dart';
import 'package:core/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:core/shared/utils/tokens.dart';

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

    if (load2 == null) {
      return const Scaffold(body: Center(child: Text('Carga no encontrada')));
    }

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
            isNew
                ? 'Registrar pesaje'.toUpperCase()
                : 'Editar pesaje'.toUpperCase(),
            style: textTheme.headlineMedium,
          ),
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.small,
            left: AppSpacing.small,
            right: AppSpacing.small,
          ),
          child: Stage3LoadForm(
            project: project,
            load2: load2,
            isNew: isNew,
            initialData: initialData,
          ),
        ),
      ),
    );
  }
}
