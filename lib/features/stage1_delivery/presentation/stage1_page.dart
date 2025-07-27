import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/widgets/stage1_load_form.dart';
import 'package:registro_panela/features/stage1_delivery/providers/index.dart';
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
        context.go(Routes.projects);
      }
      if (next.status == Stage1FormStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage ?? 'Error')));
      }
    });

    final isNew = projectId == 'new';
    final project = isNew
        ? null
        : ref.watch(stage1ProjectByIdProvider(projectId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          project == null ? 'Nuevo proyecto' : 'Modificar ${project.name}',
          style: textTheme.headlineLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(Routes.projects),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.small,
            AppSpacing.smallLarge,
            AppSpacing.small,
            AppSpacing.medium,
          ),
          child: Stage1LoadForm(initialData: project, isNew: isNew),
        ),
      ),
    );
  }
}
