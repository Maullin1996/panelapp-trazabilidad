import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/core/services/compress_file.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/widgets/two_form_row.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_form_provider.dart';
import 'package:registro_panela/shared/widgets/camera_preview_screen.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class Stage1LoadForm extends ConsumerStatefulWidget {
  final Stage1FormData? initialData;
  final bool isNew;
  const Stage1LoadForm({required this.isNew, this.initialData, super.key});

  @override
  ConsumerState<Stage1LoadForm> createState() => _Stage1FormState();
}

class _Stage1FormState extends ConsumerState<Stage1LoadForm> {
  late final GlobalKey<FormBuilderState> _formKey;
  late final List<int> _gaveras;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormBuilderState>();
    _gaveras = widget.initialData?.gaveras.asMap().keys.toList() ?? [0];
    _photoPath = widget.initialData?.photoPath;
  }

  void _addGavera() {
    setState(() {
      _gaveras.add(_gaveras.length);
    });
  }

  void _removeGavera(int index) {
    setState(() {
      _gaveras.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialData;

    final uuid = Uuid();

    final state = ref.watch(stage1FormProvider);

    final isNew = widget.isNew;

    final formNotifier = ref.read(stage1FormProvider.notifier);

    final textTheme = TextTheme.of(context);

    return Column(
      children: [
        if (state.status == Stage1FormStatus.error)
          Column(
            children: [
              Text(
                state.errorMessage ?? 'Error al guardar',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
            ],
          ),
        FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initial == null
              ? {}
              : {
                  'name': initial.name,
                  'basketsQuantity': initial.basketsQuantity.toString(),
                  'preservativesWeight': initial.preservativesWeight.toString(),
                  'preservativesJars': initial.preservativesJars.toString(),
                  'limeWeight': initial.limeWeight.toString(),
                  'limeJars': initial.limeJars.toString(),
                  'phone': initial.phone,
                  ...{
                    for (int i = 0; i < initial.gaveras.length; i++)
                      'gaverasCantidad_$i': initial.gaveras[i].quantity
                          .toString(),
                    for (var i = 0; i < initial.gaveras.length; i++)
                      'gaverasPeso_$i': initial.gaveras[i].referenceWeight
                          .toString(),
                  },
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre molienda', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.small),
              AppFormTextFild(
                name: 'name',
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: AppSpacing.small),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gaveras', style: textTheme.headlineMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: _addGavera,
                    tooltip: 'Agregar otra gavera',
                  ),
                ],
              ),
              ..._gaveras.map(
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cantidad', style: textTheme.headlineSmall),
                            const SizedBox(height: AppSpacing.small),
                            AppFormTextFild(
                              name: 'gaverasCantidad_$index',
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
                      const SizedBox(width: AppSpacing.xSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peso gavera (g)',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppSpacing.small),
                            AppFormTextFild(
                              name: 'gaverasPeso_$index',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.min(1),
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      if (_gaveras.length > 1)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () => _removeGavera(index),
                          tooltip: 'Eliminar esta gavera',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.smallLarge),
              Text('Cantidad de canastillas', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.smallLarge),
              AppFormTextFild(
                name: 'basketsQuantity',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(),
                  FormBuilderValidators.min(1),
                ]),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.smallLarge),
              TwoFormsRow(
                nameFirst: 'preservativesWeight',
                labeFirst: 'Conservantes (kg)',
                labeSecond: 'Cantidad Tarros',
                nameSecond: 'preservativesJars',
              ),
              const SizedBox(height: AppSpacing.smallLarge),
              TwoFormsRow(
                nameFirst: 'limeWeight',
                labeFirst: 'Cal (kg)',
                labeSecond: 'Cantidad Tarros',
                nameSecond: 'limeJars',
              ),
              const SizedBox(height: AppSpacing.smallLarge),
              Text('Teléfono', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.small),
              AppFormTextFild(
                name: 'phone',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.maxLength(10),
                  FormBuilderValidators.minLength(7),
                ]),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () => _onPickImage(textTheme),
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: AppColors.textDark,
                    ),
                    label: Text('Tomar Foto', style: textTheme.headlineLarge),
                  ),
                ),
              ),
              if (_photoPath != null)
                Column(
                  children: [
                    const SizedBox(height: AppSpacing.smallLarge),
                    GestureDetector(
                      onTap: () =>
                          context.push(Routes.imageViewer, extra: _photoPath),
                      child: Center(
                        child: StageImageWidget(
                          imagePath: _photoPath!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: state.status == Stage1FormStatus.submitting
                        ? null
                        : () async {
                            final isValid =
                                _formKey.currentState?.saveAndValidate() ??
                                false;
                            if (!isValid) return;

                            final values = _formKey.currentState!.value;
                            final gaveras = <GaveraData>[];
                            for (int i = 0; i < _gaveras.length; i++) {
                              final cantidad =
                                  int.tryParse(
                                    values['gaverasCantidad_$i'] ?? '',
                                  ) ??
                                  0;
                              final peso =
                                  double.tryParse(
                                    values['gaverasPeso_$i'] ?? '',
                                  ) ??
                                  0.0;
                              gaveras.add(
                                GaveraData(
                                  quantity: cantidad,
                                  referenceWeight: peso,
                                ),
                              );
                            }
                            final data = Stage1FormData(
                              id: widget.initialData?.id ?? uuid.v4(),
                              name: values['name'],
                              gaveras: gaveras,
                              basketsQuantity: int.parse(
                                values['basketsQuantity'],
                              ),
                              preservativesWeight: double.parse(
                                values['preservativesWeight'],
                              ),
                              preservativesJars: int.parse(
                                values['preservativesJars'],
                              ),
                              limeWeight: double.parse(values['limeWeight']),
                              limeJars: int.parse(values['limeJars']),
                              phone: values['phone'],
                              date: initial?.date ?? DateTime.now(),
                              photoPath: _photoPath,
                            );
                            formNotifier.submit(data, isNew: isNew);
                          },
                    child: state.status == Stage1FormStatus.submitting
                        ? const CircularProgressIndicator()
                        : Text('Guardar', style: textTheme.headlineLarge),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onPickImage(TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCrema,
        title: Text(
          'Seleccionar origen de imagen',
          style: textTheme.headlineMedium,
        ),
        actions: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromCamera();
                },
                child: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          color: AppColors.textDark,
                          size: 30,
                        ),
                        SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: Text(
                            'Cámara',
                            style: textTheme.headlineMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
                child: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo_library,
                          color: AppColors.textDark,
                          size: 30,
                        ),
                        SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: Text(
                            'Galería',
                            style: textTheme.headlineMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const CameraPreviewScreen()),
    );

    if (imagePath != null) {
      final compressed = await compressFile(imagePath);
      if (compressed != null) {
        setState(() => _photoPath = compressed);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final path = await ref
        .read(imagePickerServiceProvider)
        .pickImage(fromCamera: false);
    if (path != null) {
      final compressedPath = await compressFile(path);
      if (compressedPath != null) {
        setState(() => _photoPath = compressedPath);
      }
    }
  }
}
