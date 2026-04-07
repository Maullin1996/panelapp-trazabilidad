import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final Widget placeholder;

  /// Widget mostrado en caso de error
  final Widget errorWidget;

  const StageImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = const Center(child: CircularProgressIndicator()),
    this.errorWidget = const Center(child: Icon(Icons.broken_image)),
  });

  @override
  Widget build(BuildContext context) {
    // Si es una URL (Firebase u otra), usamos CachedNetworkImage
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => errorWidget,
        width: width,
        height: height,
        fit: fit,
      );
    }

    // En otro caso, asumimos ruta local
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: fit);
    }

    // Si no existe archivo local, mostramos errorWidget
    return errorWidget;
  }
}
