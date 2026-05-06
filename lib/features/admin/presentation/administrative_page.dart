import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'package:registro_panela/features/admin/domain/entities/app_user.dart';
import 'package:registro_panela/features/admin/providers/admin_provider.dart';
import 'package:registro_panela/features/admin/providers/change_password_controller_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

import '../../auth/presentation/providers/auth_provider.dart'; // tu provider de Auth

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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cambiar contraseña'.toUpperCase(),
            style: textTheme.headlineLarge,
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  ref.read(adminUsersControllerProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              tooltip: 'Recargar usuarios',
            ),
          ],
        ),
        body: usersState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error cargando usuarios: $e')),
          data: (users) => _buildForm(context, users, textTheme, changing),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<AppUser> users,
    TextTheme textTheme,
    bool changing,
  ) {
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: AppSpacing.small,
          right: AppSpacing.small,
          top: AppSpacing.small,
          bottom: AppSpacing.medium,
        ),
        child: Column(
          children: [
            _SectionCard(
              icon: Icons.person_outline,
              title: 'Usuario',
              iconColor: AppColors.primaryPanelaBrown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccionar usuario',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDark.withAlpha(180),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomFromDropdown<String>(
                    name: 'uid',
                    items: items,
                    validator: FormBuilderValidators.required(
                      errorText: 'Selecciona un usuario',
                    ),
                  ),
                ],
              ),
            ),
            _SectionCard(
              icon: Icons.lock_outline,
              title: 'Nueva contraseña',
              iconColor: AppColors.weight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contraseña',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDark.withAlpha(180),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  AppFormTextFild(
                    name: 'newPassword',
                    obscureText: obscureNew,
                    iconButton: IconButton(
                      onPressed: () => setState(() => obscureNew = !obscureNew),
                      icon: Icon(
                        obscureNew
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Este campo es obligatorio',
                      ),
                      FormBuilderValidators.minLength(
                        8,
                        errorText: 'Mínimo 8 caracteres',
                      ),
                    ]),
                  ),
                  const SizedBox(height: AppSpacing.smallLarge),
                  Text(
                    'Confirmar contraseña',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDark.withAlpha(180),
                      fontWeight: FontWeight.w600,
                    ),
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
                      if ((v ?? '').isEmpty) return 'Este campo es obligatorio';
                      if (pwd != v) return 'Las contraseñas no coinciden';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: changing ? null : () => _onSubmit(users),
                child: changing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.cardBackground,
                        ),
                      )
                    : Text(
                        'Cambiar contraseña',
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.cardBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
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
        CustomSnackBar.show(
          context,
          message:
              'Contraseña actualizada para ${selected.email.isNotEmpty ? selected.email : uid}',
          status: SnackbarStatus.accepted,
        );
        _fbKey.currentState?.reset();
        ref.read(changePasswordControllerProvider.notifier).reset();
      },
      error: (e, _) {
        if (!mounted) return;
        CustomSnackBar.show(
          context,
          message: 'Error: $e',
          status: SnackbarStatus.error,
        );
      },
      loading: () {}, // ya está deshabilitado el botón
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de sección
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.small,
              AppSpacing.small,
              AppSpacing.small,
              0,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: icon,
                  iconColor: iconColor,
                  backgroundColor: iconColor,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryPanelaBrown,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xSmall,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(30),
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.small,
              0,
              AppSpacing.small,
              AppSpacing.small,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
