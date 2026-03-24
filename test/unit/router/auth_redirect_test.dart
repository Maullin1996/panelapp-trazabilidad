import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/core/router/auth_redirect.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/entities/authenticated_user.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';

AuthenticatedUser _user(UserRole role) {
  return AuthenticatedUser(
    id: 'u1',
    name: 'Test',
    email: 'test@example.com',
    role: role,
    token: 'token',
  );
}

void main() {
  test('Redirects unauthenticated users to login', () {
    const auth = AuthParams(authStatus: AuthStatus.notAuthenticated);

    final redirect = authRedirectForTesting(
      auth: auth,
      path: Routes.projects,
      routeName: 'projects',
    );

    expect(redirect, Routes.login);
  });

  test('Does not redirect when already on login', () {
    const auth = AuthParams(authStatus: AuthStatus.notAuthenticated);

    final redirect = authRedirectForTesting(
      auth: auth,
      path: Routes.login,
      routeName: 'login',
    );

    expect(redirect, isNull);
  });

  test('Redirects authenticated users away from login/splash', () {
    final auth = AuthParams(
      authStatus: AuthStatus.authenticated,
      user: _user(UserRole.stage1),
    );

    final redirect = authRedirectForTesting(
      auth: auth,
      path: Routes.login,
      routeName: 'login',
    );

    expect(redirect, Routes.projects);
  });

  test('Blocks route when role does not match', () {
    final auth = AuthParams(
      authStatus: AuthStatus.authenticated,
      user: _user(UserRole.stage1),
    );

    final redirect = authRedirectForTesting(
      auth: auth,
      path: Routes.stage2,
      routeName: 'stage2Detail',
    );

    expect(redirect, Routes.projects);
  });

  test('Allows route when role matches', () {
    final auth = AuthParams(
      authStatus: AuthStatus.authenticated,
      user: _user(UserRole.stage2),
    );

    final redirect = authRedirectForTesting(
      auth: auth,
      path: Routes.stage2,
      routeName: 'stage2Detail',
    );

    expect(redirect, isNull);
  });

  test('Admin bypasses role checks', () {
    final auth = AuthParams(
      authStatus: AuthStatus.authenticated,
      user: _user(UserRole.admin),
    );

    final redirect = authRedirectForTesting(
      auth: auth,
      path: '/admin/reset-password',
      routeName: 'adminResetPassword',
    );

    expect(redirect, isNull);
  });
}