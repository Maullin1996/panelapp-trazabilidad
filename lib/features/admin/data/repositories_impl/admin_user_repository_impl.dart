import 'package:registro_panela/features/admin/data/datasources/users_remote_datasource.dart.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../datasources/admin_functions_datasource.dart';
import '../models/app_user_model.dart'; // <- para usar .toEntity()

class AdminUserRepositoryImpl implements AdminUserRepository {
  final UsersRemoteDataSource usersDs;
  final AdminFunctionsDataSource functionsDs;

  AdminUserRepositoryImpl({required this.usersDs, required this.functionsDs});

  @override
  Future<List<AppUser>> getAllUsers() async {
    final List<AppUserModel> models = await usersDs.fetchAllUsers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> changeUserPassword({
    required String uid,
    required String newPassword,
    bool revokeSessions = true,
  }) async {
    await functionsDs.changeUserPassword(
      uid: uid,
      newPassword: newPassword,
      revokeSessions: revokeSessions,
    );
  }
}
