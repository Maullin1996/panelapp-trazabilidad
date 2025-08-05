import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/providers/index.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/providers/stage4_form_provider.dart';
import 'package:registro_panela/features/stage4_recollection/providers/stage4_ui_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class Stage4Page extends ConsumerStatefulWidget {
  final String projectId;
  const Stage4Page({super.key, required this.projectId});

  @override
  ConsumerState<Stage4Page> createState() => _Stage4PageState();
}

class _Stage4PageState extends ConsumerState<Stage4Page>
    with SingleTickerProviderStateMixin {
  bool activeForm = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<Stage4FormState>(stage4FormProvider, (previous, next) {
      if (next.status == Stage4FormStatus.success) {
        setState(() => activeForm = false);
        _formKey.currentState?.reset();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Entrega registrada')));
      } else if (next.status == Stage4FormStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.errorMessage}')));
      }
    });

    final textTheme = TextTheme.of(context);
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId));
    final returns = ref.watch(stage4UiProvider(widget.projectId));
    final formNotifier = ref.read(stage4FormProvider.notifier);

    return (project == null)
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Cargando recursos..',
                    style: textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.smallLarge),
                const CircularProgressIndicator(color: AppColors.textDark),
              ],
            ),
          )
        : GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      activeForm ? Icons.save : Icons.book,
                      size: 30,
                      color: AppColors.textDark,
                    ),
                    label: Container(
                      margin: EdgeInsets.symmetric(vertical: AppSpacing.small),
                      child: Text(
                        activeForm ? 'Guardar' : 'Registrar entrega',
                        style: textTheme.headlineLarge,
                      ),
                    ),
                    onPressed: () {
                      if (activeForm) {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          return;
                        }
                        final vals = _formKey.currentState!.value;

                        final gaveras = <ReturnedGaveras>[];
                        for (int i = 0; i < project.gaveras.length; i++) {
                          gaveras.add(
                            ReturnedGaveras(
                              quantity:
                                  int.tryParse(vals['returnGavera_$i'] ?? '') ??
                                  0,
                              referenceWeight:
                                  project.gaveras[i].referenceWeight,
                            ),
                          );
                        }
                        final data = Stage4FormData(
                          id: const Uuid().v4(),
                          projectId: widget.projectId,
                          date: DateTime.now(),
                          returnedGaveras: gaveras,
                          returnedBaskets: int.parse(
                            vals['returnBaskets'] ?? '0',
                          ),
                          returnedPreservativesJars: int.parse(
                            vals['returnPreservativesJars'] ?? '0',
                          ),
                          returnedLimeJars: int.parse(
                            vals['returnLimeJars'] ?? '0',
                          ),
                        );
                        formNotifier.submit(data, isNew: true);
                      } else {
                        setState(() => activeForm = true);
                      }
                    },
                  ),
                ),
              ),
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () => context.go(Routes.projects),
                ),
                title: Text(project.name, style: textTheme.headlineLarge),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smallLarge,
                    vertical: AppSpacing.small,
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.storage,
                                color: AppColors.weight,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              Text('Gaveras', style: textTheme.headlineLarge),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.smallLarge),
                          ...List.generate(project.gaveras.length, (index) {
                            final info = project.gaveras[index];
                            final ret = returns.returnedGaveras[index].quantity;
                            return Column(
                              children: [
                                CustomRichText(
                                  firstText: '• Gavera con peso de:  ',
                                  secondText: '${info.referenceWeight} g',
                                ),
                                const SizedBox(height: AppSpacing.xSmall),
                                CustomRichText(
                                  firstText: '      Suminitradas:  ',
                                  secondText: '${info.quantity}',
                                ),
                                CustomRichText(
                                  firstText: '      Devueltas:  ',
                                  secondText: '$ret',
                                ),

                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: activeForm
                                      ? AppFormTextFild(
                                          name: 'returnGavera_$index',
                                          keyboardType: TextInputType.number,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(height: AppSpacing.small),
                              ],
                            );
                          }),
                          _buildSection(
                            icon: Icons.shopping_basket,
                            color: AppColors.register,
                            title: 'Canastillas',
                            supplied: project.basketsQuantity,
                            returned: returns.returnedBaskets,
                            fieldName: 'returnBaskets',
                          ),
                          _buildSection(
                            icon: Icons.local_drink_rounded,
                            color: AppColors.accepted,
                            title: 'Tarros de conservantes',
                            supplied: project.preservativesJars,
                            returned: returns.returnedPreservativesJars,
                            fieldName: 'returnPreservativesJars',
                          ),
                          _buildSection(
                            icon: Icons.local_drink_rounded,
                            color: AppColors.accentLightPanela,
                            title: 'Tarros de Cal',
                            supplied: project.limeJars,
                            returned: returns.returnedLimeJars,
                            fieldName: 'returnLimeJars',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildSection({
    required IconData icon,
    required Color color,
    required String title,
    required int supplied,
    required int returned,
    required String fieldName,
  }) {
    final textTheme = TextTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppSpacing.small),
            Text(title, style: textTheme.headlineLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        CustomRichText(firstText: '  Suministradas: ', secondText: '$supplied'),
        CustomRichText(
          firstText: '  Devueltas totales: ',
          secondText: '$returned',
        ),
        const SizedBox(height: AppSpacing.small),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: activeForm
              ? AppFormTextFild(
                  key: ValueKey(fieldName),
                  name: fieldName,
                  keyboardType: TextInputType.number,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.smallLarge),
      ],
    );
  }
}
