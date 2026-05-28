import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/tokens.dart';

class StageImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget errorWidget;

  // ignore: strict_top_level_inference
  const StageImageWidget({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget = const Center(child: Icon(Icons.broken_image)),
  }) : assert(
         imageUrl != null || imageBytes != null,
         'Debes proveer imageUrl o imageBytes',
       );

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, width: width, height: height, fit: fit);
    }

    if (imageUrl!.startsWith('http')) {
      if (kIsWeb) {
        return Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return _ImageShimmer(width: width ?? 100, height: height ?? 100);
          },
          errorBuilder: (_, _, _) => errorWidget,
        );
      }

      return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(AppRadius.large),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          placeholder: (_, _) =>
              _ImageShimmer(width: width ?? 100, height: height ?? 100),
          errorWidget: (_, _, _) => errorWidget,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    return _ImageError(width: width ?? 100, height: height ?? 100);
  }
}

class _ImageShimmer extends StatefulWidget {
  final double width;
  final double height;
  const _ImageShimmer({required this.width, required this.height});

  @override
  State<_ImageShimmer> createState() => _ImageShimmerState();
}

class _ImageShimmerState extends State<_ImageShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.8,
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
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.secondaryDarkPanela.withAlpha(
            (_animation.value * 60).round(),
          ),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: AppColors.secondaryDarkPanela.withAlpha(80),
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  final double width;
  final double height;
  const _ImageError({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.error.withAlpha(40)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, color: AppColors.error, size: 28),
            const SizedBox(height: 4),
            Text(
              'Sin imagen',
              style: TextStyle(fontSize: 11, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
