import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
part 'authenticated_user.freezed.dart';
part 'authenticated_user.g.dart';

/// Representa a un usuario autenticado en la aplicación.
///
/// Esta clase es inmutable y generada con **Freezed**, lo que provee:
/// - Igualdad por valor (`==`)
/// - Métodos `copyWith`
/// - Serialización/deserialización JSON
///
/// Contiene la información necesaria para identificar al usuario,
/// su rol dentro de la aplicación y el token de autenticación.
@freezed
abstract class AuthenticatedUser with _$AuthenticatedUser {
  /// Constructor principal del usuario autenticado.
  const factory AuthenticatedUser({
    /// ID único del usuario en el sistema (UUID o Firestore UID).
    required String id,

    /// Nombre completo del usuario.
    required String name,

    /// Correo electrónico registrado.
    required String email,

    /// Rol asignado dentro del sistema (admin, stage1, stage2...).
    required UserRole role,

    /// Token JWT o de sesión para autenticar peticiones al backend.
    required String token,
  }) = _AuthenticatedUser;

  /// Crea una instancia de [AuthenticatedUser] a partir de un `Map` JSON.
  ///
  /// Este método es generado automáticamente por `json_serializable`.
  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) =>
      _$AuthenticatedUserFromJson(json);
}
