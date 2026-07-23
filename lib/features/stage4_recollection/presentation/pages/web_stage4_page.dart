import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';
import 'package:registro_panela/features/stage4_recollection/domain/entities/index.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/providers.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import '../../../shared/web_layout.dart';

class WebStage4Page extends ConsumerStatefulWidget {
  final String projectId;
  const WebStage4Page({super.key, required this.projectId});

  @override
  ConsumerState<WebStage4Page> createState() => _WebStage4PageState();
}

class _WebStage4PageState extends ConsumerState<WebStage4Page> {
  bool _activeForm = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<Stage4FormState>(stage4FormProvider, (_, next) {
      if (next.status == Stage4FormStatus.success) {
        setState(() => _activeForm = false);
        _formKey.currentState?.reset();
        CustomSnackBar.show(
          context,
          message: 'Devolución registrada',
          status: SnackbarStatus.accepted,
        );
      } else if (next.status == Stage4FormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al guardar',
          status: SnackbarStatus.error,
        );
      }
    });

    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId));
    final returns = ref.watch(stage4UiProvider(widget.projectId));
    final formNotifier = ref.read(stage4FormProvider.notifier);
    final formState = ref.watch(stage4FormProvider);
    final isSubmitting = formState.status == Stage4FormStatus.submitting;
    final textTheme = TextTheme.of(context);

    if (project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                  project.name.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: isSubmitting
                      ? null
                      : () => _onTapButton(project, returns, formNotifier),
                  icon: Icon(
                    _activeForm ? Icons.check_rounded : AppIcons.pickUpSupplies,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  label: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.textLight,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _activeForm
                              ? 'Guardar registro'
                              : 'Registrar devolución',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),

          // ── Contenido ─────────────────────────────────────────
          Expanded(
            child: FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'Gaveras'),
                        const SizedBox(height: AppSpacing.small),
                        _GaverasCard(
                          gaveras: project.gaveras,
                          returned: returns.returnedGaveras,
                          activeForm: _activeForm,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _SectionLabel(label: 'Insumos'),
                        const SizedBox(height: AppSpacing.small),
                        ...List.generate(project.baskets.length, (i) {
                          final basket = project.baskets[i];
                          final returned = returns.returnedBaskets
                              .firstWhere(
                                (b) => b.size == basket.size,
                                orElse: () => ReturnedBaskets(
                                  size: basket.size,
                                  quantity: 0,
                                ),
                              )
                              .quantity;
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.small,
                            ),
                            child: _InsumoCard(
                              icon: Icons.shopping_basket,
                              iconColor: AppColors.register,
                              iconBg: AppColors.register.withAlpha(25),
                              title: 'Canastillas ${basket.size.label}',
                              supplied: basket.quantity,
                              returned: returned,
                              accentColor: AppColors.register,
                              fieldName: 'returnBaskets_$i',
                              activeForm: _activeForm,
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.small),
                        _InsumoCard(
                          icon: Icons.science_rounded,
                          iconColor: AppColors.accepted,
                          iconBg: AppColors.accepted.withAlpha(25),
                          title: 'Tarros de conservantes',
                          supplied: project.preservativesJars,
                          returned: returns.returnedPreservativesJars,
                          accentColor: AppColors.accepted,
                          fieldName: 'returnPreservativesJars',
                          activeForm: _activeForm,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        _InsumoCard(
                          icon: Icons.water_drop_rounded,
                          iconColor: AppColors.accepted,
                          iconBg: AppColors.accepted.withAlpha(25),
                          title: 'Tarros de cal',
                          supplied: project.limeJars,
                          returned: returns.returnedLimeJars,
                          accentColor: AppColors.accentLightPanela,
                          fieldName: 'returnLimeJars',
                          activeForm: _activeForm,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapButton(
    Stage1FormData project,
    Stage4UiState returns,
    formNotifier,
  ) {
    if (!_activeForm) {
      setState(() => _activeForm = true);
      return;
    }

    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final vals = _formKey.currentState!.value;

    final gaveras = <ReturnedGaveras>[];
    for (int i = 0; i < project.gaveras.length; i++) {
      gaveras.add(
        ReturnedGaveras(
          quantity: _readInt(vals['returnGavera_$i']),
          referenceWeight: project.gaveras[i].referenceWeight,
        ),
      );
    }

    final baskets = <ReturnedBaskets>[];
    for (int i = 0; i < project.baskets.length; i++) {
      baskets.add(
        ReturnedBaskets(
          size: project.baskets[i].size,
          quantity: _readInt(vals['returnBaskets_$i']),
        ),
      );
    }

    final data = Stage4FormData(
      id: const Uuid().v4(),
      projectId: widget.projectId,
      date: DateTime.now(),
      returnedGaveras: gaveras,
      returnedBaskets: baskets,
      returnedPreservativesJars: _readInt(vals['returnPreservativesJars']),
      returnedLimeJars: _readInt(vals['returnLimeJars']),
    );

    if (_isEmptySubmission(data)) {
      CustomSnackBar.show(
        context,
        message: 'No hay cambios para guardar',
        status: SnackbarStatus.info,
      );
      setState(() => _activeForm = false);
      return;
    }

    formNotifier.submit(data, isNew: true);
  }

  bool _isEmptySubmission(Stage4FormData d) {
    return d.returnedGaveras.every((g) => g.quantity == 0) &&
        d.returnedBaskets.every((b) => b.quantity == 0) &&
        d.returnedPreservativesJars == 0 &&
        d.returnedLimeJars == 0;
  }

  int _readInt(dynamic v) => int.tryParse((v ?? '').toString().trim()) ?? 0;
}

// ─── Widgets compartidos ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: AppTypography.familyRoboto,
        fontSize: AppTypography.h3,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _GaverasCard extends StatelessWidget {
  final List<GaveraData> gaveras;
  final List<ReturnedGaveras> returned;
  final bool activeForm;

  const _GaverasCard({
    required this.gaveras,
    required this.returned,
    required this.activeForm,
  });

  @override
  Widget build(BuildContext context) {
    final totalSupplied = gaveras.fold<int>(0, (s, g) => s + g.quantity);
    final totalReturned = returned.fold<int>(0, (s, r) => s + r.quantity);
    final progress = totalSupplied > 0 ? totalReturned / totalSupplied : 0.0;

    return _SurfaceCard(
      child: Column(
        children: [
          _CardHeader(
            icon: Icons.storage_rounded,
            iconColor: AppColors.weight,
            iconBg: const Color(0x1A5B6469),
            title: 'Gaveras en campo',
            trailing: Text(
              '${gaveras.length} tipos',
              style: TextStyle(
                fontFamily: AppTypography.familyRoboto,
                fontSize: AppTypography.h4,
                color: AppColors.textDark,
              ),
            ),
          ),
          ...List.generate(gaveras.length, (i) {
            final g = gaveras[i];
            final ret = returned[i].quantity;
            final remaining = g.quantity - ret;
            return _GaveraRow(
              referenceWeight: g.referenceWeight,
              supplied: g.quantity,
              returned: ret,
              remaining: remaining,
              fieldName: 'returnGavera_$i',
              activeForm: activeForm,
              isLast: i == gaveras.length - 1,
            );
          }),
          _ProgressRow(
            progress: progress,
            accentColor: AppColors.weight,
            label: 'Progreso total',
          ),
        ],
      ),
    );
  }
}

class _GaveraRow extends StatelessWidget {
  final double referenceWeight;
  final int supplied;
  final int returned;
  final int remaining;
  final String fieldName;
  final bool activeForm;
  final bool isLast;

  const _GaveraRow({
    required this.referenceWeight,
    required this.supplied,
    required this.returned,
    required this.remaining,
    required this.fieldName,
    required this.activeForm,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.weight,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${referenceWeight.toStringAsFixed(1)} kg referencia',
                  style: TextStyle(
                    fontFamily: AppTypography.familyRoboto,
                    fontSize: AppTypography.h4,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              _StatusChip(
                label: '$returned / $supplied',
                color: AppColors.accepted,
                bgAlpha: 30,
              ),
              const SizedBox(width: 6),
              _StatusChip(
                label: '$remaining pend.',
                color: remaining > 0 ? AppColors.alert : AppColors.accepted,
                bgAlpha: 20,
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: activeForm
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                  child: _StepperField(
                    name: fieldName,
                    label: 'Devolver (máx. $remaining)',
                    max: remaining,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.primaryPanelaBrown.withAlpha(25),
            indent: 14,
          ),
      ],
    );
  }
}

class _InsumoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final int supplied;
  final int returned;
  final Color accentColor;
  final String fieldName;
  final bool activeForm;

  const _InsumoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.supplied,
    required this.returned,
    required this.accentColor,
    required this.fieldName,
    required this.activeForm,
  });

  @override
  Widget build(BuildContext context) {
    final pending = supplied - returned;
    final progress = supplied > 0 ? returned / supplied : 0.0;
    final isComplete = pending == 0;

    return _SurfaceCard(
      child: Column(
        children: [
          _CardHeader(
            icon: icon,
            iconColor: iconColor,
            iconBg: iconBg,
            title: title,
            trailing: isComplete ? _CompleteBadge() : null,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                _StatCell(label: 'Sumin.', value: '$supplied'),
                _StatCell(
                  label: 'Devueltos',
                  value: '$returned',
                  valueColor: AppColors.accepted,
                ),
                _StatCell(
                  label: 'Pend.',
                  value: '$pending',
                  valueColor: pending > 0
                      ? AppColors.alert
                      : AppColors.accepted,
                  isLast: true,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.primaryPanelaBrown.withAlpha(25)),
          _ProgressRow(progress: progress, accentColor: accentColor),
          if (!isComplete)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: activeForm
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                      child: _StepperField(
                        name: fieldName,
                        label: 'Devolver ahora (máx. $pending)',
                        max: pending,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryPanelaBrown.withAlpha(25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPanelaBrown.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final Widget? trailing;

  const _CardHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryPanelaBrown.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: AppTypography.familyRoboto,
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const _StatCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppColors.primaryPanelaBrown.withAlpha(25),
                    width: 1,
                  ),
                ),
              ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppTypography.familyRoboto,
                  fontSize: AppTypography.h2,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontFamily: AppTypography.familyRoboto,
                  fontSize: AppTypography.h4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark.withAlpha(102),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final double progress;
  final Color accentColor;
  final String label;

  const _ProgressRow({
    required this.progress,
    required this.accentColor,
    this.label = 'Progreso',
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontFamily: AppTypography.familyRoboto,
                  fontSize: AppTypography.h4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontFamily: AppTypography.familyRoboto,
                  fontSize: AppTypography.h4,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (_, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor: AppColors.primaryPanelaBrown.withAlpha(25),
                valueColor: AlwaysStoppedAnimation(accentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperField extends StatefulWidget {
  final String name;
  final String label;
  final int max;

  const _StepperField({
    required this.name,
    required this.label,
    required this.max,
  });

  @override
  State<_StepperField> createState() => _StepperFieldState();
}

class _StepperFieldState extends State<_StepperField> {
  final _ctrl = TextEditingController(text: '0');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _incr() {
    final v = int.tryParse(_ctrl.text) ?? 0;
    if (v < widget.max) setState(() => _ctrl.text = '${v + 1}');
  }

  void _decr() {
    final v = int.tryParse(_ctrl.text) ?? 0;
    if (v > 0) setState(() => _ctrl.text = '${v - 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontFamily: AppTypography.familyRoboto,
            fontSize: AppTypography.h5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark.withAlpha(102),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _StepBtn(icon: Icons.remove_rounded, onTap: _decr),
            const SizedBox(width: 8),
            Expanded(
              child: FormBuilderTextField(
                name: widget.name,
                controller: _ctrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.familyRoboto,
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundCrema,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryPanelaBrown.withAlpha(51),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryPanelaBrown.withAlpha(51),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primaryPanelaBrown,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _StepBtn(icon: Icons.add_rounded, onTap: _incr),
          ],
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryPanelaBrown.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.secondaryDarkPanela),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final int bgAlpha;

  const _StatusChip({
    required this.label,
    required this.color,
    this.bgAlpha = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(bgAlpha),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTypography.familyRoboto,
          fontSize: AppTypography.h5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CompleteBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accepted.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 12, color: AppColors.accepted),
          const SizedBox(width: 4),
          Text(
            'Completo',
            style: TextStyle(
              fontFamily: AppTypography.familyRoboto,
              fontSize: AppTypography.h5,
              fontWeight: FontWeight.w600,
              color: AppColors.accepted,
            ),
          ),
        ],
      ),
    );
  }
}
