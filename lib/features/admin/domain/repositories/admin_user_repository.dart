import 'package:registro_panela/features/admin/domain/entities/app_user.dart';

abstract class AdminUserRepository {
  Future<List<AppUser>> getAllUsers();
  Future<void> changeUserPassword({
    required String uid,
    required String newPassword,
    bool revokeSessions = true,
  });
}
