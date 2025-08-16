import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/stage2_load/presentation/stage2_page.dart';
import 'package:registro_panela/features/stage2_load/presentation/widgets/stage2_load_form.dart';
import 'package:registro_panela/main.dart' as app;
import 'package:registro_panela/shared/widgets/custom_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Crear un cargue desde el role de cargue', () {
    testWidgets("flujo de etapa 1 'cargue'", (tester) async {
      app.main();
      // Evita esperar infinito:
      await tester.pump(); // primer frame
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey("login-email-input")));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey("login-email-input")),
        'cargue@panelera.com',
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
      expect(find.byType(Stage2Page), findsOneWidget);
      await tester.tap(find.byKey(ValueKey('stage2-page-create-load-button')));
      await tester.pumpAndSettle();
      expect(find.byType(Stage2LoadForm), findsOneWidget);
      await tester.tap(
        find.byKey(ValueKey('stage2-load-form-refweight-input')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('950.0')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage2-load-form-basketsCount-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage2-load-form-basketsCount-input')),
        '3',
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage2-load-form-basketWeight-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage2-load-form-basketWeight-input')),
        '30',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage2-load-form-summit-button')));
      await tester.pumpAndSettle();
      expect(find.byType(CustomCard), findsWidgets);
    });
  });
}
