import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

enum SnackbarStatus { error, accepted, warning, info }

class CustomSnackBar {
  static void showWithMessenger(
    ScaffoldMessengerState messenger, {
    required String message,
    required SnackbarStatus status,
    Duration duration = const Duration(seconds: 4),
  }) {
    _display(messenger, message: message, status: status, duration: duration);
  }

  static void show(
    BuildContext context, {
    required String message,
    required SnackbarStatus status,
    Duration duration = const Duration(seconds: 4),
  }) {
    _display(
      ScaffoldMessenger.of(context),
      message: message,
      status: status,
      duration: duration,
    );
  }

  static void _display(
    ScaffoldMessengerState messenger, {
    required String message,
    required SnackbarStatus status,
    Duration duration = const Duration(seconds: 4),
  }) {
    final config = _getConfig(status);

    messenger.clearSnackBars();
    messenger.showSnackBar(
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
          'color': AppColors.textLight,
          'bgColor': AppColors.accepted,
          'bgIcon': AppColors.accepted,
          'borderColor': AppColors.accepted.withAlpha(102),
          'icon': Icons.check_circle,
          'title': '¡Éxito!',
        };
      case SnackbarStatus.error:
        return {
          'color': AppColors.textLight,
          'bgColor': AppColors.error,
          'bgIcon': AppColors.error,
          'borderColor': AppColors.error,
          'icon': Icons.error_outline,
          'title': 'Error',
        };
      case SnackbarStatus.warning:
        return {
          'color': AppColors.textLight,
          'bgColor': Colors.amber,
          'bgIcon': Colors.amber,
          'borderColor': Colors.amber,
          'icon': Icons.warning_amber,
          'title': 'Advertencia',
        };
      case SnackbarStatus.info:
        return {
          'color': AppColors.textLight,
          'bgColor': Colors.blue,
          'bgIcon': Colors.blue,
          'borderColor': Colors.blue,
          'icon': Icons.info_outline,
          'title': 'Información',
        };
    }
  }
}
