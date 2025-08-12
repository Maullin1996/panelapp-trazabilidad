import 'package:registro_panela/features/admin/domain/repositories/admin_user_repository.dart';

class AdminChangeUserPasswordUseCase {
  final AdminUserRepository repo;
  const AdminChangeUserPasswordUseCase(this.repo);

  Future<void> call({
    required String uid,
    required String newPassword,
    bool revokeSessions = true,
  }) async {
    if (newPassword.length < 6) {
      throw ArgumentError('La contraseña debe tener al menos 8 caracteres');
    }
    await repo.changeUserPassword(
      uid: uid,
      newPassword: newPassword,
      revokeSessions: revokeSessions,
    );
  }
}
