// project_selector_shimmer.dart
import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class ProjectSelectorShimmer extends StatefulWidget {
  final int itemCount;
  const ProjectSelectorShimmer({super.key, this.itemCount = 5});

  @override
  State<ProjectSelectorShimmer> createState() => _ProjectSelectorShimmerState();
}

class _ProjectSelectorShimmerState extends State<ProjectSelectorShimmer>
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
            bottom: AppSpacing.small,
            left: AppSpacing.small,
            right: AppSpacing.small,
            top: AppSpacing.smallLarge,
          ),
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
          itemCount: widget.itemCount,
          itemBuilder: (_, _) => _ShimmerCard(opacity: _animation.value),
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double opacity;
  const _ShimmerCard({required this.opacity});

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
      padding: const EdgeInsets.all(AppSpacing.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: icono + nombre + fecha ──
          Row(
            children: [
              _ShimmerBox(
                width: 36,
                height: 36,
                color: highlight,
                radius: AppRadius.small,
              ),
              const SizedBox(width: AppSpacing.xSmall),
              _ShimmerBox(width: 140, height: 14, color: highlight),
              const Spacer(),
              _ShimmerBox(width: 60, height: 12, color: base),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(20),
            ),
          ),

          // ── Gaveras label ──
          Row(
            children: [
              _ShimmerBox(
                width: 28,
                height: 28,
                color: base,
                radius: AppRadius.small,
              ),
              const SizedBox(width: AppSpacing.xSmall),
              _ShimmerBox(width: 70, height: 13, color: base),
            ],
          ),
          const SizedBox(height: AppSpacing.xSmall),

          // ── Gavera chips (2 filas) ──
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.small),
            child: Column(
              children: List.generate(
                2,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      _ShimmerBox(
                        width: 110,
                        height: 24,
                        color: base,
                        radius: AppRadius.small,
                      ),
                      const SizedBox(width: 6),
                      _ShimmerBox(
                        width: 60,
                        height: 24,
                        color: base,
                        radius: AppRadius.small,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),

          // ── Canastillas ──
          Row(
            children: [
              _ShimmerBox(width: 20, height: 20, color: base, radius: 4),
              const SizedBox(width: 6),
              _ShimmerBox(width: 80, height: 12, color: base),
              const SizedBox(width: 4),
              _ShimmerBox(width: 30, height: 12, color: highlight),
            ],
          ),
          const SizedBox(height: AppSpacing.xSmall),

          // ── Contacto ──
          Row(
            children: [
              _ShimmerBox(width: 20, height: 20, color: base, radius: 4),
              const SizedBox(width: 6),
              _ShimmerBox(width: 60, height: 12, color: base),
              const SizedBox(width: 4),
              _ShimmerBox(width: 100, height: 12, color: highlight),
            ],
          ),
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
