// stage2_shimmer.dart
import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class Stage2Shimmer extends StatefulWidget {
  final int itemCount;
  const Stage2Shimmer({super.key, this.itemCount = 5});

  @override
  State<Stage2Shimmer> createState() => _Stage2ShimmerState();
}

class _Stage2ShimmerState extends State<Stage2Shimmer>
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
      builder: (context, _) {
        return ListView.separated(
          padding: const EdgeInsets.only(
            bottom: AppSpacing.medium,
            left: AppSpacing.small,
            right: AppSpacing.small,
            top: AppSpacing.small,
          ),
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
          itemCount: widget.itemCount,
          itemBuilder: (_, _) => _Stage2ShimmerCard(opacity: _animation.value),
        );
      },
    );
  }
}

class _Stage2ShimmerCard extends StatelessWidget {
  final double opacity;
  const _Stage2ShimmerCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final base = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 30).round(),
    );
    final highlight = AppColors.secondaryDarkPanela.withAlpha(
      (opacity * 60).round(),
    );

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
          // ── Header: icono + fecha ──
          Padding(
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
                  color: highlight,
                  radius: AppRadius.small,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                _ShimmerBox(width: 100, height: 13, color: highlight),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xSmall,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(20),
            ),
          ),

          // ── Canastillas, Peso, Gavera ──
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.small,
            ),
            child: Column(
              children: [
                _ShimmerRow(
                  iconColor: base,
                  labelWidth: 80,
                  valueWidth: 40,
                  highlight: highlight,
                  base: base,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                _ShimmerRow(
                  iconColor: base,
                  labelWidth: 60,
                  valueWidth: 60,
                  highlight: highlight,
                  base: base,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                _ShimmerRow(
                  iconColor: base,
                  labelWidth: 55,
                  valueWidth: 50,
                  highlight: highlight,
                  base: base,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  final Color iconColor;
  final double labelWidth;
  final double valueWidth;
  final Color highlight;
  final Color base;

  const _ShimmerRow({
    required this.iconColor,
    required this.labelWidth,
    required this.valueWidth,
    required this.highlight,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBox(width: 20, height: 20, color: iconColor, radius: 4),
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
