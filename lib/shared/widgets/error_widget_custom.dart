import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_projects_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class ErrorWidgetCustom extends ConsumerWidget {
  final String error;
  const ErrorWidgetCustom({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smallLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Ocurrió un error',
                style: TextTheme.of(context).headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withAlpha(51)),
                ),
                child: Text(
                  error,
                  style: TextTheme.of(
                    context,
                  ).bodyMedium?.copyWith(color: AppColors.textDark),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ref.invalidate(stage1ProjectsProvider),
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.textDark,
                    size: 20,
                  ),
                  label: const Text(
                    'Reintentar',
                    style: TextStyle(color: AppColors.textDark, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primaryPanelaBrown,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
