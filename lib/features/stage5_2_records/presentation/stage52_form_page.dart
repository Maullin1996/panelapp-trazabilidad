import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/widgets/stage52_form.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_form_status.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/shared/utils/spacing.dart';

class Stage52FormPage extends ConsumerWidget {
  final String projectId;
  final String? id;
  const Stage52FormPage({super.key, required this.projectId, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(stage52FormProvider, (previous, next) {
      if (previous?.status == Stage52FormStatus.submitting &&
          next.status == Stage52FormStatus.success) {
        context.pop();
        CustomSnackBar.show(
          context,
          message: 'Cargue registrado',
          status: SnackbarStatus.accepted,
        );
      }
      if (next.status == Stage52FormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al guardar',
          status: SnackbarStatus.error,
        );
      }
    });

    final Stage52RecordData? initialRecord = id != null
        ? ref.watch(syncStage52LoadsProvider).firstWhere((r) => r.id == id)
        : null;

    final textTheme = TextTheme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            id == null
                ? 'Nuevo registro de panela'
                : 'Editar registro de panela',
            style: textTheme.headlineLarge,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.smallLarge,
            AppSpacing.smallLarge,
            AppSpacing.smallLarge,
            AppSpacing.large,
          ),
          child: Stage52LoadForm(
            projectId: projectId,
            initialRecord: initialRecord,
          ),
        ),
      ),
    );
  }
}
