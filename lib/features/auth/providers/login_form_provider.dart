import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form_provider.freezed.dart';
part 'login_form_provider.g.dart';

/// Estado del formulario de login.
@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isValid, // Formulario válido
    @Default(false) bool isSubmitting, // Indicador de carga
  }) = _LoginFormState;
}

/// Notifier para manejar el estado y validación del formulario de login.
@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() => const LoginFormState();

  /// Actualiza el email y valida el formulario.
  void onEmailChanged(String value) {
    state = state.copyWith(email: value);
    _validate();
  }

  /// Actualiza la contraseña y valida el formulario.
  void onPasswordChanged(String value) {
    state = state.copyWith(password: value);
    _validate();
  }

  /// Valida email y contraseña.
  void _validate() {
    final validEmail = state.email.contains('@');
    final validPassword = state.password.length >= 6;
    state = state.copyWith(isValid: validEmail && validPassword);
  }

  /// Envía el formulario y llama a `login`.
  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(email: state.email, password: state.password);
    } catch (_) {}
    state = state.copyWith(isSubmitting: false);
  }
}
