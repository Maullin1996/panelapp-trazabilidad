import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:registro_panela/features/auth/presentation/providers/providers.dart';
import 'package:registro_panela/features/auth/domain/entities/index.dart';
import 'package:registro_panela/features/auth/domain/enums/index.dart';
import 'package:registro_panela/core/services/index.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _fbkey = GlobalKey<FormBuilderState>();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthParams>(authProvider, (prev, next) {
      if (next.authStatus == AuthStatus.notAuthenticated &&
          next.errorMessage != null &&
          next.errorMessage!.isNotEmpty) {
        CustomSnackBar.show(
          context,
          message: _mapErrorMessage(next.errorMessage!),
          status: SnackbarStatus.error,
        );
      }
    });

    final textTheme = TextTheme.of(context);
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    final isSubmitting = formState.isSubmitting;

    return FormBuilder(
      key: _fbkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Campo: correo ──────────────────────────────────────────
          FieldLabel(textTheme, 'Correo electrónico'),
          const SizedBox(height: AppSpacing.xSmall),
          AppFormTextFild(
            key: const Key('login-email-input'),
            name: 'email',
            hintText: 'correo@dominio.com',
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio',
              ),
              FormBuilderValidators.email(
                errorText: 'Ingresa un correo válido',
              ),
            ]),
            onChanged: (v) => formNotifier.onEmailChanged(v ?? ''),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Campo: contraseña ──────────────────────────────────────
          FieldLabel(textTheme, 'Contraseña'),
          const SizedBox(height: AppSpacing.xSmall),
          AppFormTextFild(
            key: const Key('login-password-input'),
            name: 'password',
            obscureText: _obscure,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'Este campo es obligatorio',
              ),
              FormBuilderValidators.minLength(
                6,
                errorText: 'Mínimo 6 caracteres',
              ),
            ]),
            onChanged: (v) => formNotifier.onPasswordChanged(v ?? ''),
            iconButton: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.secondaryDarkPanela,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.medium),

          // ── Botón: iniciar sesión ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const Key('login-enter-button'),
              onPressed: (formState.isValid && !isSubmitting)
                  ? () async {
                      if (_fbkey.currentState?.saveAndValidate() ?? false) {
                        await formNotifier.submit();
                      }
                    }
                  : null,
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.cardBackground,
                      ),
                    )
                  : Text(
                      'Iniciar sesión',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.cardBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

String _mapErrorMessage(String error) {
  if (error.contains('wrong-password') ||
      error.contains('invalid-credential')) {
    return 'Correo o contraseña incorrectos';
  }
  if (error.contains('user-not-found')) {
    return 'No existe una cuenta con ese correo';
  }
  if (error.contains('too-many-requests')) {
    return 'Demasiados intentos. Intenta más tarde';
  }
  if (error.contains('network-request-failed')) {
    return 'Sin conexión a internet';
  }
  return 'Error al iniciar sesión. Intenta de nuevo';
}
