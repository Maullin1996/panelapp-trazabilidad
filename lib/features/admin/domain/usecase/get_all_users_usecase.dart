import 'package:registro_panela/features/admin/domain/repositories/admin_user_repository.dart';

import '../entities/app_user.dart';

class GetAllUsersUseCase {
  final AdminUserRepository repo;
  const GetAllUsersUseCase(this.repo);

  Future<List<AppUser>> call() => repo.getAllUsers();
}
