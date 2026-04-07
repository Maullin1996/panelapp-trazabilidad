import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_form_provider.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_ui_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:uuid/uuid.dart';

// ─── Page ─────────────────────────────────────────────────────────────────────
class Stage4Page extends ConsumerStatefulWidget {
  final String projectId;
  const Stage4Page({super.key, required this.projectId});

  @override
  ConsumerState<Stage4Page> createState() => _Stage4PageState();
}

class _Stage4PageState extends ConsumerState<Stage4Page>
    with SingleTickerProviderStateMixin {
  bool _activeForm = false;
  final _formKey = GlobalKey<FormBuilderState>();
  late AnimationController _btnController;
  late Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _btnScale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _btnController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

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

    if (project == null) return _buildLoading();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCrema,
        appBar: _buildAppBar(context, project.name),
        body: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Sección Gaveras ──────────────────────────────────────
                _SectionLabel(label: 'Gaveras'),
                const SizedBox(height: 6),
                _GaverasCard(
                  gaveras: project.gaveras,
                  returned: returns.returnedGaveras,
                  activeForm: _activeForm,
                ),
                const SizedBox(height: 16),

                // ── Sección Insumos ──────────────────────────────────────
                _SectionLabel(label: 'Insumos'),
                const SizedBox(height: 6),
                _InsumoCard(
                  icon: AppIcons.collect,
                  iconColor: AppColors.register,
                  iconBg: AppColors.register.withAlpha(25),
                  title: 'Canastillas',
                  supplied: project.basketsQuantity,
                  returned: returns.returnedBaskets,
                  accentColor: AppColors.register,
                  fieldName: 'returnBaskets',
                  activeForm: _activeForm,
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                _InsumoCard(
                  icon: Icons.water_drop_rounded,
                  iconColor: AppColors.accentLightPanela,
                  iconBg: AppColors.accentLightPanela.withAlpha(38),
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
        bottomNavigationBar: _buildBottomBar(
          project: project,
          returns: returns,
          formNotifier: formNotifier,
          isSubmitting: formState.status == Stage4FormStatus.submitting,
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    final textTheme = TextTheme.of(context);
    return AppBar(
      leading: BackButton(onPressed: () => context.pop()),
      title: Text(title, style: textTheme.headlineLarge),
    );
  }

  // ── Bottom bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar({
    required project,
    required returns,
    required formNotifier,
    required bool isSubmitting,
  }) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundCrema,
          border: Border(
            top: BorderSide(
              color: AppColors.primaryPanelaBrown.withAlpha(31),
              width: 1,
            ),
          ),
        ),
        child: ScaleTransition(
          scale: _btnScale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 52,
            decoration: BoxDecoration(
              color: _activeForm
                  ? AppColors.secondaryDarkPanela
                  : AppColors.primaryPanelaBrown,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPanelaBrown.withAlpha(77),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: isSubmitting
                    ? null
                    : () => _onTapButton(project, returns, formNotifier),
                onTapDown: (_) => _btnController.forward(),
                onTapUp: (_) => _btnController.reverse(),
                onTapCancel: () => _btnController.reverse(),
                child: Center(
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColors.textLight,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _activeForm
                                  ? Icons.check_rounded
                                  : AppIcons.pickUpSupplies,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _activeForm
                                  ? 'Guardar registro'
                                  : 'Registrar devolución',
                              style: const TextStyle(
                                fontFamily: AppTypography.familyRoboto,
                                fontSize: AppTypography.h3,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Lógica del botón ───────────────────────────────────────────────────────
  void _onTapButton(project, returns, formNotifier) {
    HapticFeedback.lightImpact();

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
          quantity: int.tryParse(vals['returnGavera_$i'] ?? '') ?? 0,
          referenceWeight: project.gaveras[i].referenceWeight,
        ),
      );
    }

    final data = Stage4FormData(
      id: const Uuid().v4(),
      projectId: widget.projectId,
      date: DateTime.now(),
      returnedGaveras: gaveras,
      returnedBaskets: _readInt(vals['returnBaskets']),
      returnedPreservativesJars: _readInt(vals['returnPreservativesJars']),
      returnedLimeJars: _readInt(vals['returnLimeJars']),
    );

    if (_isEmptySubmission(data)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay cambios para guardar')),
      );
      setState(() => _activeForm = false);
      return;
    }

    final remainingPreservatives =
        project.preservativesJars - returns.returnedPreservativesJars;
    final remainingLime = project.limeJars - returns.returnedLimeJars;
    final gaverasExceed = gaveras.asMap().entries.any(
      (e) =>
          e.value.quantity >
          project.gaveras[e.key].quantity -
              returns.returnedGaveras[e.key].quantity,
    );

    if (data.returnedPreservativesJars > remainingPreservatives ||
        data.returnedLimeJars > remainingLime ||
        gaverasExceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad supera el máximo permitido')),
      );
      return;
    }

    formNotifier.submit(data, isNew: true);
  }

  bool _isEmptySubmission(Stage4FormData d) {
    return d.returnedGaveras.every((g) => g.quantity == 0) &&
        d.returnedBaskets == 0 &&
        d.returnedPreservativesJars == 0 &&
        d.returnedLimeJars == 0;
  }

  int _readInt(dynamic v) => int.tryParse((v ?? '').toString().trim()) ?? 0;

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cargando recursos...',
              style: TextStyle(
                fontFamily: AppTypography.familyRoboto,
                fontSize: AppTypography.body,
                color: AppColors.textDark.withAlpha(128),
              ),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(
              color: AppColors.primaryPanelaBrown,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: AppTypography.familyRoboto,
          fontSize: AppTypography.h3,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Gaveras Card ─────────────────────────────────────────────────────────────
class _GaverasCard extends StatelessWidget {
  final List gaveras;
  final List returned;
  final bool activeForm;

  const _GaverasCard({
    required this.gaveras,
    required this.returned,
    required this.activeForm,
  });

  @override
  Widget build(BuildContext context) {
    final totalSupplied = gaveras.fold<int>(
      0,
      (s, g) => s + (g.quantity as int),
    );
    final totalReturned = returned.fold<int>(
      0,
      (s, r) => s + (r.quantity as int),
    );
    final progress = totalSupplied > 0 ? totalReturned / totalSupplied : 0.0;

    return _SurfaceCard(
      child: Column(
        children: [
          // Header
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

          // Filas de gaveras
          ...List.generate(gaveras.length, (i) {
            final g = gaveras[i];
            final ret = returned[i].quantity as int;
            final remaining = (g.quantity as int) - ret;
            return _GaveraRow(
              referenceWeight: g.referenceWeight as double,
              supplied: g.quantity as int,
              returned: ret,
              remaining: remaining,
              fieldName: 'returnGavera_$i',
              activeForm: activeForm,
              isLast: i == gaveras.length - 1,
            );
          }),

          // Progress
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
              // Chips de estado
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
        // Input animado
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

// ─── Insumo Card ──────────────────────────────────────────────────────────────
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
          // Header
          _CardHeader(
            icon: icon,
            iconColor: iconColor,
            iconBg: iconBg,
            title: title,
            trailing: isComplete ? _CompleteBadge() : null,
          ),

          // Stats row: 3 celdas
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

          // Progress
          _ProgressRow(progress: progress, accentColor: accentColor),

          // Input animado (solo si hay pendientes)
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

// ─── Shared widgets ────────────────────────────────────────────────────────────

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
                letterSpacing: -0.2,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (trailing != null) trailing!,
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
              builder: (_, value, __) => LinearProgressIndicator(
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

// ─── Stepper Field (reemplaza StyledInput) ────────────────────────────────────
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
            // Botón −
            _StepBtn(icon: Icons.remove_rounded, onTap: _decr),
            const SizedBox(width: 8),
            // Campo numérico (también acepta teclado)
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
            // Botón +
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
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
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

// ─── Status chip ───────────────────────────────────────────────────────────────
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

// ─── Complete badge ────────────────────────────────────────────────────────────
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
