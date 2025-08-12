import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/features/auth/providers/login_form_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';

/// Formulario de inicio de sesión.
///
/// Usa `loginFormProvider` para manejar el estado de los campos y
/// `authProvider` para ejecutar el login.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _fbkey = GlobalKey<FormBuilderState>();
  bool obscure = true; // Controla visibilidad de la contraseña

  @override
  Widget build(BuildContext context) {
    // Escucha cambios de estado de autenticación
    ref.listen<AuthParams>(authProvider, (previous, next) {
      if (previous?.authStatus != next.authStatus) {
        if (next.authStatus == AuthStatus.authenticated) {
          context.go('/splash'); // Redirige si login exitoso
        } else if (next.authStatus == AuthStatus.notAuthenticated &&
            next.errorMessage?.isNotEmpty == true) {
          // Muestra mensaje de error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        }
      }
    });

    final textTheme = TextTheme.of(context);
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
    final authNotifier = ref.read(authProvider.notifier);

    return FormBuilder(
      key: _fbkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo usuario
          Text('Usuario:', style: textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.small),
          AppFormTextFild(
            name: 'email',
            hintText: 'correo@dominio.com',
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
            onChanged: (v) => formNotifier.onEmailChanged(v ?? ''),
          ),

          const SizedBox(height: AppSpacing.medium),

          // Campo contraseña
          Text('Contraseña:', style: textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.small),
          AppFormTextFild(
            name: 'password',
            obscureText: obscure,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
            ]),
            onChanged: (v) => formNotifier.onPasswordChanged(v ?? ''),
            iconButton: IconButton(
              onPressed: () => setState(() => obscure = !obscure),
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.mediumLarge),

          // Botón de envío o indicador de carga
          formState.isSubmitting
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: formState.isValid
                          ? () async {
                              if (_fbkey.currentState?.saveAndValidate() ??
                                  false) {
                                await authNotifier.login(
                                  email: formState.email,
                                  password: formState.password,
                                );
                              }
                            }
                          : null,
                      child: Text(
                        'Iniciar sesión',
                        style: textTheme.headlineLarge,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
