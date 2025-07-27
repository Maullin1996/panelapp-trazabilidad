import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_form_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:uuid/uuid.dart';

class Stage3LoadForm extends ConsumerStatefulWidget {
  final Stage1FormData project;
  final Stage2LoadData load2;
  final Stage3FormData? initialData;
  final bool isNew;

  const Stage3LoadForm({
    required this.project,
    required this.load2,
    this.initialData,
    required this.isNew,
    super.key,
  });

  @override
  ConsumerState<Stage3LoadForm> createState() => _Stage3LoadFormState();
}

class _Stage3LoadFormState extends ConsumerState<Stage3LoadForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final List<int> _indices;
  late final double _refWeightPerBasket;
  late final int _totalBaskets;
  late final Map<int, String> _photoPaths;

  @override
  void initState() {
    super.initState();
    final baskets = widget.load2.baskets;
    _totalBaskets = baskets.count;
    _refWeightPerBasket = baskets.referenceWeight;
    _indices = List.generate(_totalBaskets, (index) => index);
    _photoPaths = {
      for (var i in _indices)
        i: widget.initialData != null
            ? widget.initialData!.baskets[i].photoPath
            : '',
    };
  }

  Future<void> _pickImage(int index) async {
    final service = ref.read(imagePickerServiceProvider);
    final path = await service.pickImage(fromCamera: true);
    if (path != null) {
      setState(() {
        _photoPaths[index] = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final formState = ref.watch(stage3FormProvider);
    final formNotifier = ref.read(stage3FormProvider.notifier);
    final uuid = const Uuid();
    final initMap = <String, dynamic>{};
    if (widget.initialData != null) {
      for (BasketWeighData element in widget.initialData!.baskets) {
        initMap['realWeight_${element.sequence}'] = element.realWeight
            .toString();
        initMap['quality_${element.sequence}'] = element.quality.name;
      }
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        initialValue: initMap,
        child: Column(
          children: [
            ...List.generate(
              _indices.length,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Bordes redondeados
                  side: BorderSide(
                    color: AppColors.inputBorder, // Color del borde
                    width: 2, // Grosor del borde
                  ),
                ),
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Canastilla #${index + 1}',
                          style: textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Peso real (kg)', style: textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      AppFormTextFild(
                        name: 'realWeight_$index',
                        label: 'Peso real (kg)',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Text('Calidad', style: textTheme.headlineMedium),
                      const SizedBox(height: 8),

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
                          border: Border.all(
                            color: AppColors.inputBorder,
                            width: 2,
                          ),
                        ),
                        child: FormBuilderDropdown<String>(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.small,
                            vertical: AppSpacing.small,
                          ),
                          name: 'quality_$index',
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: BasketQuality.values.map((e) {
                            return DropdownMenuItem(
                              value: e.name,
                              child: Text(
                                e.name.toUpperCase(),
                                style: textTheme.bodyLarge,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(index),
                          icon: const Icon(Icons.camera_alt),
                          label: Text('Tomar foto'),
                        ),
                      ),
                      if (_photoPaths[index]?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Image.file(
                          File(_photoPaths[index]!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: formState.status == Stage3FormStatus.submitting
                  ? null
                  : () async {
                      if (!(_formKey.currentState?.saveAndValidate() ??
                          false)) {
                        return;
                      }
                      final values = _formKey.currentState!.value;
                      final baskets = <BasketWeighData>[];
                      for (final i in _indices) {
                        final raw = values['realWeight_$i'] as String?;
                        final qual = values['quality_$i'] as String?;
                        if (raw != null &&
                            raw.isNotEmpty &&
                            qual != null &&
                            qual.isNotEmpty) {
                          baskets.add(
                            BasketWeighData(
                              id:
                                  widget.initialData?.baskets[i].id ??
                                  uuid.v4(),
                              sequence: i,
                              referenceWeight: _refWeightPerBasket,
                              realWeight: double.parse(raw),
                              quality: BasketQuality.values.firstWhere(
                                (q) => q.name == qual,
                              ),
                              photoPath: _photoPaths[i] ?? '',
                            ),
                          );
                        }
                      }
                      final formData = Stage3FormData(
                        id: widget.initialData?.id ?? uuid.v4(),
                        projectId: widget.project.id,
                        stage2LoadId: widget.load2.id,
                        date: widget.initialData?.date ?? DateTime.now(),
                        baskets: baskets,
                      );
                      formNotifier.submit(formData, isNew: widget.isNew);
                    },
              child: formState.status == Stage3FormStatus.submitting
                  ? const CircularProgressIndicator()
                  : Text(widget.isNew ? 'Register' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
