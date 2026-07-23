import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/providers.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import '../../../shared/web_layout.dart';

class WebStage53FormPage extends ConsumerWidget {
  final String projectId;
  final String? id;
  const WebStage53FormPage({super.key, required this.projectId, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(stage52FormProvider, (previous, next) {
      if (previous?.status == Stage52FormStatus.submitting &&
          next.status == Stage52FormStatus.success) {
        context.pop();
        CustomSnackBar.show(
          context,
          message: 'Registro guardado',
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
        ? ref
              .watch(syncStage52LoadsProvider)
              .firstWhereOrNull((r) => r.id == id)
        : null;

    final textTheme = TextTheme.of(context);

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
                  id == null
                      ? 'Nuevo registro de panela'.toUpperCase()
                      : 'Editar registro de panela'.toUpperCase(),
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
                  child: Stage53LoadForm(
                    projectId: projectId,
                    initialRecord: initialRecord,
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
