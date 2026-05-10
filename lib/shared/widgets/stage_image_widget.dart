import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

/// Widget que muestra una imagen local o remota con caching.
class StageImageWidget extends StatelessWidget {
  /// Ruta del archivo local o URL remota
  final String imagePath;

  /// Ancho deseado (opcional)
  final double? width;

  /// Alto deseado (opcional)
  final double? height;

  /// BoxFit para ajustar la imagen
  final BoxFit fit;

  /// Widget mostrado mientras carga la imagen remota

  /// Widget mostrado en caso de error
  final Widget errorWidget;

  const StageImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget = const Center(child: Icon(Icons.broken_image)),
  });

  @override
  Widget build(BuildContext context) {
    // Si es una URL (Firebase u otra), usamos CachedNetworkImage
    if (imagePath.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(AppRadius.large),
        child: CachedNetworkImage(
          imageUrl: imagePath,
          placeholder: (_, _) =>
              _ImageShimmer(width: width ?? 100, height: height ?? 100),
          errorWidget: (_, _, _) => errorWidget,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    // En otro caso, asumimos ruta local
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: fit);
    }

    // Si no existe archivo local, mostramos errorWidget
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
