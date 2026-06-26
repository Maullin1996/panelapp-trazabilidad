import 'package:flutter/material.dart';
import '../utils/tokens.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;

  const EmptyWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.medium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundCrema,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? 'No hay proyectos',
              textAlign: TextAlign.center,
              style: TextTheme.of(
                context,
              ).headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
