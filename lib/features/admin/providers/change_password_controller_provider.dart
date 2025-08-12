import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/admin/domain/usecase/admin_change_user_password_usecase.dart';
import 'package:registro_panela/features/admin/providers/admin_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_controller_provider.g.dart';

@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> submit({
    required String uid,
    required String newPassword,
    bool revokeSessions = true,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uc = ref.read(changePasswordUseCaseProvider);
      await uc(
        uid: uid,
        newPassword: newPassword,
        revokeSessions: revokeSessions,
      );
    });
  }

  void reset() => state = const AsyncData(null);
}

@riverpod
AdminChangeUserPasswordUseCase changePasswordUseCase(Ref ref) =>
    AdminChangeUserPasswordUseCase(ref.read(adminUserRepositoryProvider));
