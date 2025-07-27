import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_load_form_provider.dart';
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

    final uuid = Uuid();

    final textTheme = TextTheme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
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
              SizedBox(height: AppSpacing.small),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, 1),
                      color: Colors.black.withAlpha(50),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.inputBorder, width: 2),
                ),
                child: FormBuilderDropdown<double>(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: AppSpacing.small,
                  ),
                  name: 'referenceWeight',
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: widget.project.gaveras
                      .map(
                        (g) => DropdownMenuItem(
                          value: g.referenceWeight,
                          child: Text(
                            '${g.referenceWeight} g',
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
              ),
              const SizedBox(height: 16),
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
                              name: 'basketsCount',
                              label: 'Cantidad de canastillas',
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.integer(),
                                FormBuilderValidators.min(1),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Peso (kg)', style: textTheme.headlineMedium),
                            AppFormTextFild(
                              name: 'basketWeight',
                              label: 'Peso de referencia (kg)',
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: formState.status == Stage2FormStatus.submitting
                    ? null
                    : () {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          return;
                        }
                        final values = _formKey.currentState!.value;
                        final data = Stage2LoadData(
                          id: init?.id ?? uuid.v4(),
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
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Guardar cargue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
