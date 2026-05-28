import 'package:flutter/material.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final textTheme = TextTheme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenSize.height),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.mediumSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.height * 0.12),

                    // ── Logo ──────────────────────────────────────────
                    Hero(
                      tag: 'app-logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 110,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.small),

                    // ── Título ────────────────────────────────────────
                    Text(
                      key: const Key('login-message'),
                      'Registro Panela',
                      style: textTheme.headlineLarge?.copyWith(
                        color: AppColors.primaryPanelaBrown,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xSmall),

                    Text(
                      'Inicia sesión para continuar',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textDark.withAlpha(140),
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.06),

                    // ── Tarjeta del formulario ─────────────────────────
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: CustomCard(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.small),
                          child: const LoginForm(),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.medium),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
