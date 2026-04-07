import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

enum SnackbarStatus { error, accepted, warning, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarStatus status,
    Duration duration = const Duration(seconds: 4),
  }) {
    final config = _getConfig(status);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Center(
              child: Icon(
                config['icon'] as IconData,
                color: config['color'] as Color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    config['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: config['bgColor'] as Color,
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: config['borderColor'] as Color, width: 1.5),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
      ),
    );
  }

  static Map<String, dynamic> _getConfig(SnackbarStatus status) {
    switch (status) {
      case SnackbarStatus.accepted:
        return {
          'color': AppColors.accepted,
          'bgColor': AppColors.accepted.withAlpha(150),
          'bgIcon': AppColors.accepted.withAlpha(230),
          'borderColor': AppColors.accepted.withAlpha(102),
          'icon': Icons.check_circle,
          'title': '¡Éxito!',
        };
      case SnackbarStatus.error:
        return {
          'color': AppColors.error,
          'bgColor': AppColors.error.withAlpha(100),
          'bgIcon': AppColors.error.withAlpha(230),
          'borderColor': AppColors.error.withAlpha(102),
          'icon': Icons.error_outline,
          'title': 'Error',
        };
      case SnackbarStatus.warning:
        return {
          'color': Colors.amber,
          'bgColor': Colors.amber.withAlpha(100),
          'bgIcon': Colors.amber.withAlpha(230),
          'borderColor': Colors.amber.withAlpha(102),
          'icon': Icons.warning_amber,
          'title': 'Advertencia',
        };
      case SnackbarStatus.info:
        return {
          'color': Colors.blue,
          'bgColor': Colors.blue.withAlpha(100),
          'bgIcon': Colors.blue.withAlpha(230),
          'borderColor': Colors.blue.withAlpha(102),
          'icon': Icons.info_outline,
          'title': 'Información',
        };
    }
  }
}
