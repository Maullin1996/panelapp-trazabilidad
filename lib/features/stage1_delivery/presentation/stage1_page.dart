import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/widgets/stage1_load_form.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class Stage1Page extends ConsumerWidget {
  final String projectId;
  const Stage1Page({required this.projectId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);

    ref.listen<Stage1FormState>(stage1FormProvider, (prev, next) {
      if (prev?.status == Stage1FormStatus.submitting &&
          next.status == Stage1FormStatus.success) {
        CustomSnackBar.show(
          context,
          message: 'Formulario subido correctamente',
          status: SnackbarStatus.accepted,
        );
        context.pop();
      }
      if (next.status == Stage1FormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al subir el formulario',
          status: SnackbarStatus.error,
        );
      }
    });

    final isNew = projectId == 'new';
    final project = isNew
        ? null
        : ref.watch(stage1ProjectByIdProvider(projectId));
    if (!isNew && project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            project == null ? 'Nuevo proyecto' : 'Modificar ${project.name}',
            style: textTheme.headlineLarge,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.small,
                AppSpacing.smallLarge,
                AppSpacing.small,
                AppSpacing.medium,
              ),
              child: Stage1LoadForm(initialData: project, isNew: isNew),
            ),
          ),
        ),
      ),
    );
  }
}
