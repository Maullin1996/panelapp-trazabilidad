import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/widgets/stage52_form.dart';
import 'package:registro_panela/features/stage5_2_records/providers/stage52_form_status.dart';
import 'package:registro_panela/shared/utils/spacing.dart';

class Stage52FormPage extends ConsumerWidget {
  final String projectId;
  const Stage52FormPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(stage52FormProvider, (previous, next) {
      if (previous?.status == Stage52FormStatus.submitting &&
          next.status == Stage52FormStatus.success) {
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cargue registrado')));
      }
      if (next.status == Stage52FormStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error al guardar')),
        );
      }
    });
    final textTheme = TextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nuevo registro de panela', style: textTheme.headlineLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.smallLarge,
          AppSpacing.smallLarge,
          AppSpacing.smallLarge,
          AppSpacing.large,
        ),
        child: Stage52LoadForm(projectId: projectId),
      ),
    );
  }
}
