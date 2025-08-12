import 'package:registro_panela/features/auth/domin/entities/authenticated_user.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';

/// Modela el estado de autenticación actual de la app.
///
/// Esta clase es **inmutable** y se usa como _state_ dentro de los
/// providers de autenticación. Centraliza:
/// - El usuario autenticado (si existe)
/// - El estatus del flujo de auth (checking / authenticated / notAuthenticated / error)
/// - Un posible mensaje de error para depurar o mostrar feedback controlado
///
/// Buenas prácticas:
/// - Mantén `authStatus` en `AuthStatus.checking` mientras validas sesión (token/refresh).
/// - En caso de error, coloca `authStatus = AuthStatus.error` y llena `errorMessage`.
/// - Evita exponer mensajes de bajo nivel al usuario final; mapea a textos de UI.
class AuthParams {
  /// Usuario autenticado, o `null` si no hay sesión activa.
  final AuthenticatedUser? user;

  /// Estatus del flujo de autenticación.
  ///
  /// Valores típicos del enum `AuthStatus`:
  /// - `checking`: verificando sesión (splash / arranque)
  /// - `authenticated`: hay sesión válida
  /// - `notAuthenticated`: no hay sesión o se cerró sesión
  /// - `error`: ocurrió un fallo durante login/refresh/validación
  final AuthStatus authStatus;

  /// Mensaje de error opcional para depuración o para mapear a la UI.
  ///
  /// Nota: evita mostrar este texto "tal cual" al usuario final si contiene
  /// detalles técnicos. Úsalo para logs o para mapear a un mensaje amigable.
  final String? errorMessage;

  /// Crea un estado de autenticación.
  ///
  /// Por defecto, el estatus arranca en `AuthStatus.checking` mientras
  /// la app valida si existe una sesión previa.
  const AuthParams({
    this.user,
    this.authStatus = AuthStatus.checking,
    this.errorMessage,
  });

  AuthParams copyWith({
    AuthenticatedUser? user,
    AuthStatus? authStatus,
    String? errorMessage,
  }) {
    return AuthParams(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
