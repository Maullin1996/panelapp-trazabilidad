import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/auth/domain/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domain/enums/auth_status.dart';
import 'package:registro_panela/features/auth/presentation/providers/auth_provider.dart';
import 'package:registro_panela/features/auth/presentation/providers/login_form_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/shared/widgets/field_label.dart';

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
    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (previous?.authStatus != next.authStatus &&
          next.authStatus == AuthStatus.notAuthenticated) {
        CustomSnackBar.show(
          context,
          message: 'Usuario inválido o revisar conexión',
          status: SnackbarStatus.error,
        );
      }
    });

    final textTheme = TextTheme.of(context);
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    final authNotifier = ref.read(authProvider.notifier);
    final isChecking =
        ref.watch(authProvider).authStatus == AuthStatus.checking;
    final isSubmitting = formState.isSubmitting || isChecking;

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
                        await authNotifier.login(
                          email: formState.email,
                          password: formState.password,
                        );
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
