import 'package:registro_panela/features/auth/domin/entities/authenticated_user.dart';

/// Contrato para manejar autenticación de usuarios.
abstract class AuthRepository {
  /// Inicia sesión y retorna el usuario autenticado.
  Future<AuthenticatedUser> signIn({
    required String email,
    required String password,
  });

  /// Cierra la sesión actual.
  Future<void> signOut();
}
