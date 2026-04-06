import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/stage2_load_form_provider.dart';
import 'package:registro_panela/shared/widgets/custom_from_dropdown.dart';
import 'package:uuid/uuid.dart';

class Stage2LoadForm extends ConsumerStatefulWidget {
  final Stage1FormData project;
  final Stage2LoadData? initialData;
  final bool isNew;
  const Stage2LoadForm({
    this.isNew = true,
    required this.project,
    this.initialData,
    super.key,
  });

  @override
  ConsumerState<Stage2LoadForm> createState() => _Stage2LoadFormState();
}

class _Stage2LoadFormState extends ConsumerState<Stage2LoadForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final Uuid _uuid;

  @override
  void initState() {
    super.initState();
    _uuid = Uuid();
  }

  @override
  Widget build(BuildContext context) {
    final init = widget.initialData;
    final Map<String, dynamic> initialMap = init != null
        ? {
            'referenceWeight': init.baskets.referenceWeight,
            'basketsCount': init.baskets.count.toString(),
            'basketWeight': init.baskets.realWeight.toString(),
          }
        : {};

    final formState = ref.watch(stage2FormProvider);

    final formNotifier = ref.read(stage2FormProvider.notifier);

    final textTheme = TextTheme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.mediumSmall,
          horizontal: AppSpacing.smallLarge,
        ),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialMap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Peso de referencia de la gavera',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.small),
              CustomFromDropdown<double>(
                key: Key('stage2-load-form-refweight-input'),
                name: 'referenceWeight',
                items: widget.project.gaveras
                    .map(
                      (g) => DropdownMenuItem(
                        key: Key('${g.referenceWeight}'),
                        value: g.referenceWeight,
                        child: Text(
                          '${g.referenceWeight} g',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    )
                    .toList(),
                validator: FormBuilderValidators.required(
                  errorText: "Este campo es obligatorio",
                ),
              ),

              const SizedBox(height: AppSpacing.smallLarge),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Canastillas',
                              style: textTheme.headlineMedium,
                            ),
                            AppFormTextFild(
                              key: Key('stage2-load-form-basketsCount-input'),
                              name: 'basketsCount',
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Este campo es obligatorio",
                                ),
                                FormBuilderValidators.integer(
                                  errorText: "Debe de ser un valor entero",
                                ),
                                FormBuilderValidators.min(1),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.smallLarge),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Peso (kg)', style: textTheme.headlineMedium),
                            AppFormTextFild(
                              key: Key('stage2-load-form-basketWeight-input'),
                              name: 'basketWeight',
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Este campo es obligatorio",
                                ),
                                FormBuilderValidators.numeric(
                                  errorText:
                                      "debe ser un valor númerico y si es decimal debe de ser punto",
                                ),
                                FormBuilderValidators.min(1),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.mediumSmall),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  key: Key('stage2-load-form-summit-button'),
                  onPressed: formState.status == Stage2FormStatus.submitting
                      ? null
                      : () {
                          if (!(_formKey.currentState?.saveAndValidate() ??
                              false)) {
                            return;
                          }
                          final values = _formKey.currentState!.value;
                          final data = Stage2LoadData(
                            id: init?.id ?? _uuid.v4(),
                            projectId: widget.project.id,
                            date: init?.date ?? DateTime.now(),
                            baskets: BasketLoadData(
                              referenceWeight:
                                  values['referenceWeight'] as double,
                              count: int.parse(values['basketsCount']),
                              realWeight: double.parse(
                                values['basketWeight'] as String,
                              ),
                            ),
                          );
                          formNotifier.submit(data, isNew: widget.isNew);
                        },
                  child: formState.status == Stage2FormStatus.submitting
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : Text('Guardar cargue', style: textTheme.headlineLarge),
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        ),
      ),
    );
  }
}
