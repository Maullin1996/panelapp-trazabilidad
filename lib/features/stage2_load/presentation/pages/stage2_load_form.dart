import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uuid/uuid.dart';

import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/stage2_load_form_provider.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

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
    _uuid = const Uuid();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Stage2FormState>(stage2FormProvider, (previous, next) {
      if (previous?.status == Stage2FormStatus.submitting &&
          next.status == Stage2FormStatus.success) {
        Navigator.of(context).pop();
      }
    });

    final init = widget.initialData;
    final formState = ref.watch(stage2FormProvider);
    final formNotifier = ref.read(stage2FormProvider.notifier);
    final textTheme = TextTheme.of(context);
    final isSubmitting = formState.status == Stage2FormStatus.submitting;

    final Map<String, dynamic> initialMap = init != null
        ? {
            'referenceWeight': init.baskets.referenceWeight,
            'basketsCount': init.baskets.count.toString(),
            'quality': init.baskets.quality,
          }
        : {};

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialMap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle del modal ───────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.small),
              decoration: BoxDecoration(
                color: AppColors.secondaryDarkPanela.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.small,
              0,
              AppSpacing.small,
              AppSpacing.small,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPanelaBrown.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(
                    Icons.inbox_outlined,
                    size: 18,
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isNew ? 'Nuevo cargue' : 'Editar cargue',
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryPanelaBrown,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.project.name,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textDark.withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.secondaryDarkPanela.withAlpha(30),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.small,
              AppSpacing.small,
              AppSpacing.small,
              AppSpacing.medium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Gavera ──────────────────────────────────────────
                FieldLabel(textTheme, 'Peso de referencia de la gavera'),
                const SizedBox(height: AppSpacing.xSmall),
                CustomFromDropdown<double>(
                  key: const Key('stage2-load-form-refweight-input'),
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
                    errorText: 'Este campo es obligatorio',
                  ),
                ),

                const SizedBox(height: AppSpacing.small),

                // ── Canastillas y peso ───────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel(textTheme, 'Canastillas'),
                          const SizedBox(height: AppSpacing.xSmall),
                          AppFormTextFild(
                            key: const Key(
                              'stage2-load-form-basketsCount-input',
                            ),
                            name: 'basketsCount',
                            hintText: '0',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: 'Obligatorio',
                              ),
                              FormBuilderValidators.integer(
                                errorText: 'Valor entero',
                              ),
                              FormBuilderValidators.min(1),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel(textTheme, 'Calidad'),
                          const SizedBox(height: AppSpacing.xSmall),
                          CustomFromDropdown<BasketQuality>(
                            key: const Key('stage2-load-form-quality-input'),
                            name: 'quality',
                            items: BasketQuality.values
                                .map(
                                  (q) => DropdownMenuItem<BasketQuality>(
                                    key: Key('basket_quality_${q.name}'),
                                    value: q,
                                    child: Text(
                                      q.label,
                                      style: textTheme.bodyLarge,
                                    ),
                                  ),
                                )
                                .toList(),
                            validator: FormBuilderValidators.required(
                              errorText: 'Obligatorio',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.mediumSmall),

                // ── Botón guardar ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    key: const Key('stage2-load-form-summit-button'),
                    onPressed: isSubmitting
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
                                quality:
                                    values['quality']
                                        as BasketQuality, // ← reemplaza realWeight
                              ),
                            );
                            formNotifier.submit(data, isNew: widget.isNew);
                          },
                    child: isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.cardBackground,
                            ),
                          )
                        : Text(
                            'Guardar cargue',
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.cardBackground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showStage2LoadModal(BuildContext context, Stage1FormData project) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.cardBackground,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.large),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        top: AppSpacing.small,
      ),
      child: Stage2LoadForm(isNew: true, project: project),
    ),
  );
}
