import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/providers/stage52_form_status.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/shared/widgets/custom_from_dropdown.dart';
import 'package:uuid/uuid.dart';

class Stage52LoadForm extends ConsumerStatefulWidget {
  final String projectId;
  const Stage52LoadForm({super.key, required this.projectId});

  @override
  ConsumerState<Stage52LoadForm> createState() => _Stage52FormPageState();
}

class _Stage52FormPageState extends ConsumerState<Stage52LoadForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId))!;
    final formState = ref.watch(stage52FormProvider);
    final formNotifier = ref.read(stage52FormProvider.notifier);
    final textTheme = TextTheme.of(context);

    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gavera', style: textTheme.headlineLarge),
          SizedBox(height: AppSpacing.small),
          // 1) Selector de gaveraWeight
          CustomFromDropdown<double>(
            name: 'gaveras',
            items: project.gaveras
                .map(
                  (g) => DropdownMenuItem(
                    value: g.referenceWeight,
                    child: Text('${g.referenceWeight} g'),
                  ),
                )
                .toList(),
            validator: FormBuilderValidators.required(),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          Text('Peso de panela (kg)', style: textTheme.headlineLarge),
          SizedBox(height: AppSpacing.small),
          // 2) Peso de panela
          AppFormTextFild(
            name: 'panelaWeight',
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
            ]),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          Text('Unidades de panela', style: textTheme.headlineLarge),
          SizedBox(height: AppSpacing.small),
          // 3) Unidades
          AppFormTextFild(
            name: 'unitCount',
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.integer(),
            ]),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          Text('Calidad', style: textTheme.headlineLarge),
          SizedBox(height: AppSpacing.small),
          // 4) Calidad
          CustomFromDropdown(
            name: 'quality',
            items: BasketQuality.values
                .map(
                  (q) => DropdownMenuItem(
                    value: q.name,
                    child: Text(q.name.toUpperCase()),
                  ),
                )
                .toList(),
            validator: FormBuilderValidators.required(),
          ),

          const SizedBox(height: AppSpacing.mediumLarge),
          // 5) Foto
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () async {
                final path = await ref
                    .read(imagePickerServiceProvider)
                    .pickImage(fromCamera: true);
                if (path != null) {
                  setState(() => _photoPath = path);
                }
              },
              icon: const Icon(
                Icons.camera_alt,
                color: AppColors.textDark,
                size: 30,
              ),
              label: Text('Tomar foto', style: textTheme.headlineLarge),
            ),
          ),
          if (_photoPath != null) ...[
            const SizedBox(height: AppSpacing.mediumLarge),
            Center(
              child: Image.file(File(_photoPath!), width: 300, height: 300),
            ),
          ],

          const SizedBox(height: AppSpacing.smallMedium),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: formState.status == Stage52FormStatus.submitting
                    ? null
                    : () {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          return;
                        }
                        final v = _formKey.currentState!.value;
                        final record = Stage52RecordData(
                          id: _uuid.v4(),
                          projectId: widget.projectId,
                          date: DateTime.now(),
                          gaveraWeight: v['gaveras'] as double,
                          panelaWeight: double.parse(v['panelaWeight']),
                          unitCount: int.parse(v['unitCount']),
                          quality: BasketQuality.values.firstWhere(
                            (q) => q.name == v['quality'],
                          ),
                          photoPath: _photoPath ?? '',
                        );
                        formNotifier.submit(data: record);
                      },
                child: Text('Guardar registro', style: textTheme.headlineLarge),
              ),
            ),
          ),

          if (formState.status == Stage52FormStatus.error)
            Text('Error: ${formState.errorMessage}'),
        ],
      ),
    );
  }

  String? _photoPath;
}
