import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

enum SnackbarStatus { error, accepted }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarStatus status,
  }) {
    final color = status == SnackbarStatus.error
        ? AppColors.error
        : AppColors.accepted;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }
}
