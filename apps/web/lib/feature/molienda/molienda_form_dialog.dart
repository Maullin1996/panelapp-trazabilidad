import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uuid/uuid.dart';

import 'package:core/features/molienda/domain/entities/molienda.dart';
import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class MoliendaFormDialog extends ConsumerStatefulWidget {
  final Molienda? molienda;
  final bool isNew;

  const MoliendaFormDialog({required this.isNew, this.molienda, super.key});

  @override
  ConsumerState<MoliendaFormDialog> createState() =>
      _MoliendaFormDialogState();
}

class _MoliendaFormDialogState extends ConsumerState<MoliendaFormDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<MoliendaFormState>(moliendaFormProvider, (previous, next) {
      if (previous?.status == MoliendaFormStatus.submitting &&
          next.status == MoliendaFormStatus.success) {
        Navigator.of(context).pop();
      }
    });

    final textTheme = TextTheme.of(context);
    final formState = ref.watch(moliendaFormProvider);
    final isSubmitting = formState.status == MoliendaFormStatus.submitting;
    final molienda = widget.molienda;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isNew ? 'Agregar molienda' : 'Editar molienda',
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.medium),
        FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: molienda == null
              ? {}
              : {'nombre': molienda.nombre, 'telefono': molienda.telefono},
          child: SectionCard(
            icon: Icons.factory_outlined,
            iconColor: AppColors.primaryPanelaBrown,
            title: 'Datos de la molienda',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Nombre'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  name: 'nombre',
                  hintText: 'Ej. Molienda El Paraíso',
                  validator: FormBuilderValidators.required(
                    errorText: 'Este campo es obligatorio',
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                FieldLabel(textTheme, 'Teléfono'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  name: 'telefono',
                  hintText: '300 000 0000',
                  keyboardType: TextInputType.phone,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Este campo es obligatorio',
                    ),
                    FormBuilderValidators.numeric(errorText: 'Solo números'),
                    FormBuilderValidators.maxLength(10),
                    FormBuilderValidators.minLength(7),
                  ]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: textTheme.bodyLarge),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            ElevatedButton(
              onPressed: isSubmitting ? null : _onSubmit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.cardBackground,
                      ),
                    )
                  : Text(
                      'Guardar',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.cardBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    final values = _formKey.currentState!.value;

    final molienda = Molienda(
      id: widget.molienda?.id ?? const Uuid().v4(),
      nombre: values['nombre'] as String,
      telefono: values['telefono'] as String,
      creadoEn: widget.molienda?.creadoEn ?? DateTime.now(),
    );

    await ref
        .read(moliendaFormProvider.notifier)
        .save(molienda, isNew: widget.isNew);
  }
}
