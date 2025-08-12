import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Control de acceso por estado de auth y rol
String? authRedirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  final path = state.uri.path;

  if (auth.authStatus == AuthStatus.checking) {
    return path != '/splash' ? '/splash' : Routes.splash;
  }

  if (auth.authStatus == AuthStatus.notAuthenticated) {
    return path != Routes.login ? Routes.login : null;
  }

  if (auth.authStatus == AuthStatus.authenticated) {
    if (path == '/splash' || path == Routes.login) {
      return Routes.projects;
    }

    // Verificar permisos para otras rutas
    return _checkRolePermissions(auth, state);
  }

  return null;
}

String? _checkRolePermissions(AuthParams auth, GoRouterState state) {
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
    'adminResetPassword': UserRole.admin,
  };

  final routeName = state.name;
  final requiredRole = routeName != null ? roleByName[routeName] : null;

  if (requiredRole != null &&
      auth.user?.role != requiredRole &&
      auth.user?.role != UserRole.admin) {
    return Routes.projects;
  }

  return null;
}
