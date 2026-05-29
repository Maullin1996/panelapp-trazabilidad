import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:core/features/stage1_delivery/providers/index.dart';
import 'package:core/core/services/custom_snack_bar.dart';
import 'package:core/shared/utils/tokens.dart';
import '../shared/web_layout.dart';
import 'web_stage1_form.dart';

class WebStage1Page extends ConsumerWidget {
  final String projectId;
  const WebStage1Page({required this.projectId, super.key});

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
                      ? 'Nuevo proyecto'.toUpperCase()
                      : 'Modificar ${project!.name}'.toUpperCase(),
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
                  child: WebStage1Form(initialData: project, isNew: isNew),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
