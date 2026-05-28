import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:registro_panela/features/admin/data/datasources/admin_functions_datasource.dart';
import 'package:registro_panela/features/admin/data/datasources/users_remote_datasource.dart.dart';
import 'package:registro_panela/features/admin/data/repositories_impl/admin_user_repository_impl.dart';
import 'package:registro_panela/features/admin/domain/entities/app_user.dart';
import 'package:registro_panela/features/admin/domain/repositories/admin_user_repository.dart';
import 'package:registro_panela/features/admin/domain/usecase/admin_change_user_password_usecase.dart';
import 'package:registro_panela/features/admin/domain/usecase/get_all_users_usecase.dart';

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  final usersDs = UsersRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
  final functionsDs = AdminFunctionsDataSourceImpl(
    functions: FirebaseFunctions.instance,
  );
  return AdminUserRepositoryImpl(usersDs: usersDs, functionsDs: functionsDs);
});

final getAllUsersUseCaseProvider = Provider<GetAllUsersUseCase>((ref) {
  return GetAllUsersUseCase(ref.read(adminUserRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<AdminChangeUserPasswordUseCase>((
  ref,
) {
  return AdminChangeUserPasswordUseCase(ref.read(adminUserRepositoryProvider));
});

class AdminUsersController extends AsyncNotifier<List<AppUser>> {
  @override
  Future<List<AppUser>> build() async {
    final usecase = ref.read(getAllUsersUseCaseProvider);
    return usecase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final usecase = ref.read(getAllUsersUseCaseProvider);
      return usecase();
    });
  }
}

final adminUsersControllerProvider =
    AsyncNotifierProvider<AdminUsersController, List<AppUser>>(
      AdminUsersController.new,
    );
