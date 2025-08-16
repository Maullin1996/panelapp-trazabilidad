import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/stage1_page.dart';
import 'package:registro_panela/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Crear un proyecto desde el role de entrega', () {
    testWidgets("flujo de etapa 1 'entrega'", (tester) async {
      app.main();
      // Evita esperar infinito:
      await tester.pump(); // primer frame
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey("login-email-input")));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey("login-email-input")),
        'entrega@panelera.com',
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey("login-email-input")),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey("login-password-input")));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey("login-password-input")),
        '123456789',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('login-message')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('login-enter-button')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          ValueKey(
            'project-selector-custom-card-775b0b55-f08e-486b-9e92-fa52ad1b446d',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Stage1Page), findsOneWidget);
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-molienda-name-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-molienda-name-input')),
        'Don juan',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage1_load_forma_name_text')));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-molienda-name-input')),
        const Offset(0, -800),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage1-load-form-summit-button')));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byKey(
            ValueKey(
              'project-selector-custom-card-775b0b55-f08e-486b-9e92-fa52ad1b446d',
            ),
          ),
          matching: find.text('Don juan'),
        ),
        findsOneWidget,
      );
    });
  });
}
