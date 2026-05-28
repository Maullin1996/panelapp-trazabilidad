import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../packages/core/lib/features/auth/domain/entities/auth_status.dart';
import '../../packages/core/lib/features/auth/domain/enums/auth_status.dart';
import '../../packages/core/lib/features/auth/presentation/providers/auth_provider.dart';
import '../../packages/core/lib/features/splash/splash_screen.dart';

class _TestAuth extends Auth {
  int checkCalls = 0;

  @override
  AuthParams build() => const AuthParams(authStatus: AuthStatus.checking);

  @override
  Future<void> checkAuthStatus() async {
    checkCalls++;
  }

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('SplashScreen shows branding and triggers auth check', (
    tester,
  ) async {
    final auth = _TestAuth();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authProvider.overrideWith(() => auth)],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    expect(find.text('Registro Panela'), findsOneWidget);
    expect(find.text('Verificando sesión...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump();

    expect(auth.checkCalls, 1);
  });
}
