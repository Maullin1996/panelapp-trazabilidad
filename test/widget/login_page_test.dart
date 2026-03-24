import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/auth/domin/entities/auth_status.dart';
import 'package:registro_panela/features/auth/domin/enums/auth_status.dart';
import 'package:registro_panela/features/auth/presentation/login_page.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';

class _TestAuth extends Auth {
  _TestAuth(this.initialStatus);

  final AuthStatus initialStatus;
  int loginCalls = 0;

  @override
  AuthParams build() => AuthParams(authStatus: initialStatus);

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls++;
    state = state.copyWith(authStatus: AuthStatus.authenticated);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> checkAuthStatus() async {}
}

Finder _editableTextUnder(Key parentKey) {
  return find.descendant(
    of: find.byKey(parentKey),
    matching: find.byType(EditableText),
  );
}

void main() {
  testWidgets('LoginPage renders welcome message and fields', (tester) async {
    final auth = _TestAuth(AuthStatus.notAuthenticated);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => auth),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.byKey(const Key('login-message')), findsOneWidget);
    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.byKey(const Key('login-email-input')), findsOneWidget);
    expect(find.byKey(const Key('login-password-input')), findsOneWidget);
    expect(find.byKey(const Key('login-enter-button')), findsOneWidget);
  });

  testWidgets('LoginForm enables submit with valid inputs', (tester) async {
    final auth = _TestAuth(AuthStatus.notAuthenticated);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => auth),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    final buttonFinder = find.byKey(const Key('login-enter-button'));
    ElevatedButton button = tester.widget(buttonFinder);
    expect(button.onPressed, isNull);

    await tester.enterText(
      _editableTextUnder(const Key('login-email-input')),
      'test@example.com',
    );
    await tester.enterText(
      _editableTextUnder(const Key('login-password-input')),
      '123456',
    );
    await tester.pump();

    button = tester.widget(buttonFinder);
    expect(button.onPressed, isNotNull);
  });

  testWidgets('LoginForm toggles password visibility icon', (tester) async {
    final auth = _TestAuth(AuthStatus.notAuthenticated);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => auth),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('LoginForm calls auth login on submit', (tester) async {
    final auth = _TestAuth(AuthStatus.notAuthenticated);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => auth),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.enterText(
      _editableTextUnder(const Key('login-email-input')),
      'test@example.com',
    );
    await tester.enterText(
      _editableTextUnder(const Key('login-password-input')),
      '123456',
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('login-enter-button')));
    await tester.pump();

    expect(auth.loginCalls, 1);
  });

  testWidgets('LoginForm shows progress indicator when auth is checking', (
    tester,
  ) async {
    final auth = _TestAuth(AuthStatus.checking);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => auth),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}