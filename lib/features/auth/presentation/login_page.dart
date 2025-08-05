import 'package:flutter/material.dart';
import 'package:registro_panela/features/auth/presentation/widgets/login_form.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.medium,
              horizontal: AppSpacing.mediumSmall,
            ),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.18),
                Text(
                  'Bienvenido',
                  style: TextTheme.of(
                    context,
                  ).headlineLarge?.copyWith(fontSize: AppTypography.h1),
                ),
                const SizedBox(height: AppSpacing.medium),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
