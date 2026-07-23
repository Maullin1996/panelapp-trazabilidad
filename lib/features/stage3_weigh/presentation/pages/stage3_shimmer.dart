// stage3_shimmer.dart
import 'package:flutter/material.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';

class Stage3Shimmer extends StatefulWidget {
  final int itemCount;
  const Stage3Shimmer({super.key, this.itemCount = 4});

  @override
  State<Stage3Shimmer> createState() => _Stage3ShimmerState();
}

class _Stage3ShimmerState extends State<Stage3Shimmer>
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
      builder: (_, _) => ListView.separated(
        padding: const EdgeInsets.only(
          bottom: AppSpacing.medium,
          left: AppSpacing.small,
          right: AppSpacing.small,
          top: AppSpacing.smallLarge,
        ),
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
        itemCount: widget.itemCount,
        itemBuilder: (_, _) => _Stage3ShimmerCard(opacity: _animation.value),
      ),
    );
  }
}

class _Stage3ShimmerCard extends StatelessWidget {
  final double opacity;
  const _Stage3ShimmerCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final base = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 30).round(),
    );
    final highlight = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 60).round(),
    );
    final errorBase = AppColors.error.withAlpha((opacity * 20).round());

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.secondaryDarkPanela.withAlpha(20),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sección 1: Molienda ──
          _ShimmerSectionHeader(
            iconColor: AppColors.alert.withAlpha((opacity * 60).round()),
            labelWidth: 160,
            highlight: highlight,
          ),
          _shimmerDivider(),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.smallLarge,
            ),
            child: Column(
              children: [
                _ShimmerRow(
                  labelWidth: 50,
                  valueWidth: 80,
                  base: base,
                  highlight: highlight,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                _ShimmerRow(
                  labelWidth: 70,
                  valueWidth: 90,
                  base: base,
                  highlight: highlight,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                _ShimmerRow(
                  labelWidth: 90,
                  valueWidth: 60,
                  base: base,
                  highlight: highlight,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                _ShimmerRow(
                  labelWidth: 110,
                  valueWidth: 70,
                  base: base,
                  highlight: highlight,
                ),
              ],
            ),
          ),

          // ── Sección 2: Bodega ──
          _ShimmerSectionHeader(
            iconColor: AppColors.register.withAlpha((opacity * 60).round()),
            labelWidth: 150,
            highlight: highlight,
          ),
          _shimmerDivider(),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.smallLarge,
            ),
            child: Column(
              children: [
                _ShimmerRow(
                  labelWidth: 80,
                  valueWidth: 90,
                  base: base,
                  highlight: highlight,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                _ShimmerRow(
                  labelWidth: 110,
                  valueWidth: 70,
                  base: base,
                  highlight: highlight,
                ),
              ],
            ),
          ),

          // ── Sección 3: Faltantes ──
          _ShimmerSectionHeader(
            iconColor: errorBase,
            labelWidth: 170,
            highlight: errorBase,
          ),
          _shimmerDivider(),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.xSmall,
            ),
            child: Column(
              children: [
                _ShimmerRow(
                  labelWidth: 100,
                  valueWidth: 30,
                  base: errorBase,
                  highlight: errorBase,
                ),
                const SizedBox(height: AppSpacing.small),
                _ShimmerRow(
                  labelWidth: 85,
                  valueWidth: 55,
                  base: base,
                  highlight: highlight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.xSmall,
      ),
      child: Container(
        height: 1,
        color: AppColors.secondaryDarkPanela.withAlpha(20),
      ),
    );
  }
}

class _ShimmerSectionHeader extends StatelessWidget {
  final Color iconColor;
  final double labelWidth;
  final Color highlight;

  const _ShimmerSectionHeader({
    required this.iconColor,
    required this.labelWidth,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.small,
        right: AppSpacing.small,
        top: AppSpacing.xSmall,
      ),
      child: Row(
        children: [
          _ShimmerBox(
            width: 36,
            height: 36,
            color: iconColor,
            radius: AppRadius.small,
          ),
          const SizedBox(width: AppSpacing.xSmall),
          _ShimmerBox(width: labelWidth, height: 13, color: highlight),
        ],
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  final double labelWidth;
  final double valueWidth;
  final Color base;
  final Color highlight;

  const _ShimmerRow({
    required this.labelWidth,
    required this.valueWidth,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBox(width: 20, height: 20, color: base, radius: 4),
        const SizedBox(width: 6),
        _ShimmerBox(width: labelWidth, height: 12, color: base),
        const SizedBox(width: 4),
        _ShimmerBox(width: valueWidth, height: 12, color: highlight),
      ],
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
