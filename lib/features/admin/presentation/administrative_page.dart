import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/admin/domain/entities/app_user.dart';
import 'package:registro_panela/features/admin/providers/admin_provider.dart';
import 'package:registro_panela/features/admin/providers/change_password_controller_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

import '../../auth/providers/auth_provider.dart'; // tu provider de Auth

class AdminResetPasswordPage extends ConsumerStatefulWidget {
  const AdminResetPasswordPage({super.key});

  @override
  ConsumerState<AdminResetPasswordPage> createState() =>
      _AdminResetPasswordPageState();
}

class _AdminResetPasswordPageState
    extends ConsumerState<AdminResetPasswordPage> {
  final _fbKey = GlobalKey<FormBuilderState>();
  bool obscureNew = true;
  bool obscureConfirme = true;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isAdmin = auth.user?.role.name == 'admin';
    final textTheme = TextTheme.of(context);

    if (!isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text('Solo administradores pueden acceder a esta pantalla'),
        ),
      );
    }

    final usersState = ref.watch(adminUsersControllerProvider);
    final changing = ref.watch(changePasswordControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar contraseña', style: textTheme.headlineLarge),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(adminUsersControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar usuarios',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.smallLarge),
          child: usersState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error cargando usuarios: $e')),
            data: (users) {
              // Armamos items del dropdown: value = uid, label = email o displayName
              final items = users
                  .map(
                    (u) => DropdownMenuItem<String>(
                      value: u.uid,
                      child: Text(u.displayName ?? u.email),
                    ),
                  )
                  .toList();

              return FormBuilder(
                key: _fbKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.medium),
                    Text('Usuario', style: textTheme.headlineLarge),
                    const SizedBox(height: AppSpacing.xSmall),
                    CustomFromDropdown<String>(
                      name: 'uid',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      items: items,
                    ),
                    const SizedBox(height: AppSpacing.smallLarge),

                    Text('Nueva contraseña', style: textTheme.headlineLarge),
                    const SizedBox(height: AppSpacing.xSmall),
                    AppFormTextFild(
                      name: 'newPassword',
                      obscureText: obscureNew,
                      iconButton: IconButton(
                        onPressed: () =>
                            setState(() => obscureNew = !obscureNew),
                        icon: Icon(
                          obscureNew
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(8), // política mínima
                      ]),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Confirmar contraseña',
                      style: textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    AppFormTextFild(
                      name: 'confirmPassword',
                      obscureText: obscureConfirme,
                      iconButton: IconButton(
                        onPressed: () =>
                            setState(() => obscureConfirme = !obscureConfirme),
                        icon: Icon(
                          obscureConfirme
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      validator: (v) {
                        final pwd =
                            _fbKey.currentState?.fields['newPassword']?.value
                                as String?;
                        if ((v ?? '').isEmpty) return 'Campo requerido';
                        if (pwd != v) return 'Las contraseñas no coinciden';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: changing ? null : () => _onSubmit(users),
                        child: changing
                            ? const CircularProgressIndicator()
                            : Text(
                                'Cambiar contraseña',
                                style: textTheme.headlineLarge,
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(List<AppUser> users) async {
    if (!(_fbKey.currentState?.saveAndValidate() ?? false)) return;

    final uid = _fbKey.currentState!.fields['uid']!.value as String;
    final newPassword =
        _fbKey.currentState!.fields['newPassword']!.value as String;

    // (Opcional) obtener email para el mensaje
    final selected = users.firstWhere(
      (u) => u.uid == uid,
      orElse: () => const AppUser(uid: '', email: '', role: 'user'),
    );

    await ref
        .read(changePasswordControllerProvider.notifier)
        .submit(uid: uid, newPassword: newPassword, revokeSessions: true);

    final result = ref.read(changePasswordControllerProvider);
    result.when(
      data: (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Contraseña actualizada para ${selected.email.isNotEmpty ? selected.email : uid}',
            ),
          ),
        );
        _fbKey.currentState?.reset();
        ref.read(changePasswordControllerProvider.notifier).reset();
      },
      error: (e, _) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      },
      loading: () {}, // ya está deshabilitado el botón
    );
  }
}
