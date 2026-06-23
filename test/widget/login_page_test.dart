import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/features/auth/providers/login_form_provider.dart'
    show LoginFormState, loginFormProvider;
import 'package:core/shared/widgets/login_form.dart';

Finder _editableTextUnder(Key parentKey) {
  return find.descendant(
    of: find.byKey(parentKey),
    matching: find.byType(EditableText),
  );
}

void main() {
  testWidgets('LoginForm renderiza campos de correo, contraseña y botón', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: LoginForm())),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('login-email-input')), findsOneWidget);
    expect(find.byKey(const Key('login-password-input')), findsOneWidget);
    expect(find.byKey(const Key('login-enter-button')), findsOneWidget);
  });

  testWidgets('LoginForm habilita submit con datos válidos', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: LoginForm())),
      ),
    );
    await tester.pump();

    final buttonFinder = find.byKey(const Key('login-enter-button'));
    final ElevatedButton buttonBefore = tester.widget(buttonFinder);
    expect(buttonBefore.onPressed, isNull);

    await tester.enterText(
      _editableTextUnder(const Key('login-email-input')),
      'test@example.com',
    );
    await tester.enterText(
      _editableTextUnder(const Key('login-password-input')),
      '123456',
    );
    await tester.pump();

    final ElevatedButton buttonAfter = tester.widget(buttonFinder);
    expect(buttonAfter.onPressed, isNotNull);
  });

  testWidgets('LoginForm alterna visibilidad de contraseña', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: LoginForm())),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
