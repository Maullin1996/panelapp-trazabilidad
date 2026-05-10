// stage52_shimmer.dart
import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class Stage52Shimmer extends StatefulWidget {
  final int itemCount;
  const Stage52Shimmer({super.key, this.itemCount = 6});

  @override
  State<Stage52Shimmer> createState() => _Stage52ShimmerState();
}

class _Stage52ShimmerState extends State<Stage52Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xSmall,
          AppSpacing.xSmall,
          AppSpacing.xSmall,
          100,
        ),
        itemCount: widget.itemCount + 1, // +1 para el summary bar
        itemBuilder: (_, i) {
          if (i == 0) return _SummaryBarShimmer(opacity: _animation.value);
          return _Stage52ShimmerCard(opacity: _animation.value);
        },
      ),
    );
  }
}

// ── Summary bar shimmer ───────────────────────────────────────────────────────

class _SummaryBarShimmer extends StatelessWidget {
  final double opacity;
  const _SummaryBarShimmer({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final base = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 30).round(),
    );
    final highlight = AppColors.primaryPanelaBrown.withAlpha(
      (opacity * 40).round(),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.primaryPanelaBrown.withAlpha(18),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          _SummaryItemShimmer(valueColor: highlight, labelColor: base),
          Container(
            width: 0.5,
            height: 36,
            color: AppColors.textDark.withAlpha(12),
          ),
          _SummaryItemShimmer(valueColor: highlight, labelColor: base),
          Container(
            width: 0.5,
            height: 36,
            color: AppColors.textDark.withAlpha(12),
          ),
          _SummaryItemShimmer(
            valueColor: highlight,
            labelColor: base,
            valueWidth: 70,
          ),
        ],
      ),
    );
  }
}

class _SummaryItemShimmer extends StatelessWidget {
  final Color valueColor;
  final Color labelColor;
  final double valueWidth;

  const _SummaryItemShimmer({
    required this.valueColor,
    required this.labelColor,
    this.valueWidth = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _ShimmerBox(width: valueWidth, height: 18, color: valueColor),
          const SizedBox(height: 4),
          _ShimmerBox(width: 50, height: 10, color: labelColor),
        ],
      ),
    );
  }
}

// ── Record card shimmer ───────────────────────────────────────────────────────

class _Stage52ShimmerCard extends StatelessWidget {
  final double opacity;
  const _Stage52ShimmerCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final base = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 25).round(),
    );
    final highlight = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 55).round(),
    );
    final accent = AppColors.primaryPanelaBrown.withAlpha(
      (opacity * 40).round(),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: AppColors.textDark.withAlpha(8),
            width: 0.5,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Acento lateral ──
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.large),
                    bottomLeft: Radius.circular(AppRadius.large),
                  ),
                ),
              ),

              // ── Contenido ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de calidad
                      _ShimmerBox(
                        width: 70,
                        height: 22,
                        color: accent,
                        radius: 20,
                      ),
                      const SizedBox(height: 8),

                      // Métricas
                      _MetricRowShimmer(
                        iconColor: AppColors.accepted.withAlpha(
                          (opacity * 40).round(),
                        ),
                        labelWidth: 55,
                        valueWidth: 30,
                        base: base,
                        highlight: highlight,
                      ),
                      _MetricRowShimmer(
                        iconColor: AppColors.register.withAlpha(
                          (opacity * 40).round(),
                        ),
                        labelWidth: 45,
                        valueWidth: 40,
                        base: base,
                        highlight: highlight,
                      ),
                      _MetricRowShimmer(
                        iconColor: AppColors.weight.withAlpha(
                          (opacity * 40).round(),
                        ),
                        labelWidth: 55,
                        valueWidth: 50,
                        base: base,
                        highlight: highlight,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Foto placeholder ──
              Padding(
                padding: const EdgeInsets.all(8),
                child: _ShimmerBox(
                  width: 120,
                  height: 72,
                  color: base,
                  radius: AppRadius.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRowShimmer extends StatelessWidget {
  final Color iconColor;
  final double labelWidth;
  final double valueWidth;
  final Color base;
  final Color highlight;

  const _MetricRowShimmer({
    required this.iconColor,
    required this.labelWidth,
    required this.valueWidth,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
      child: Row(
        children: [
          _ShimmerBox(
            width: 28,
            height: 28,
            color: iconColor,
            radius: AppRadius.small,
          ),
          const SizedBox(width: 4),
          _ShimmerBox(width: labelWidth, height: 11, color: base),
          const SizedBox(width: 4),
          _ShimmerBox(width: valueWidth, height: 12, color: highlight),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.color,
    this.radius = AppRadius.small,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
