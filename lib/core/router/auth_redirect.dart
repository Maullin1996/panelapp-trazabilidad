import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Control de acceso por estado de auth y rol
String? authRedirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  final path = state.uri.path;
  print(
    '🔄 authRedirect → path: $path, authStatus: ${auth.authStatus}, role: ${auth.user?.role}',
  );
  final isChecking = auth.authStatus == AuthStatus.checking;
  final isAuth = auth.authStatus == AuthStatus.authenticated;
  final isAnon = auth.authStatus == AuthStatus.notAuthenticated;

  if (isChecking) {
    return '/splash';
  }

  if (isAnon && path != Routes.login) {
    return Routes.login;
  }

  if (isAuth && path == Routes.login) {
    return Routes.projects;
  }

  if (isAuth) {
    final roleByName = <String, UserRole>{
      'stage1': UserRole.stage1,
      'stage2Detail': UserRole.stage2,
      'stage3Detail': UserRole.stage3,
      'stage3Form': UserRole.stage3,
      'stage3Summary': UserRole.stage3,
      'stage4Detail': UserRole.stage4,
      'stage5page': UserRole.stage5,
      'stage5summary': UserRole.stage5,
      'stage5report': UserRole.stage5,
      'stage5records': UserRole.stage5,
      'stage52form': UserRole.stage5,
      'stage52summary': UserRole.stage5,
    };

    final routeName = state.name;
    final requiredRole = routeName != null ? roleByName[routeName] : null;

    if (requiredRole != null &&
        auth.user?.role != requiredRole &&
        auth.user?.role != UserRole.admin) {
      return Routes.projects;
    }
  }

  return null;
}
