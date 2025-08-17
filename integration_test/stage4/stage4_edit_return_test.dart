import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/project_selector/presentation/project_selector_page.dart';
import 'package:registro_panela/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("etapa 4: registrar devolución (solo canastillas y cal)", (
    tester,
  ) async {
    app.main();
    await tester.pump(); // primer frame
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Login (usuario de finalización)
    await tester.enterText(
      find.byKey(const ValueKey("login-email-input")),
      'finalizacion@panelera.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey("login-password-input")),
      '123456789',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('login-message')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('login-enter-button')));
    await tester.pumpAndSettle();

    // Ir al proyecto existente (usa el mismo id que en tus pruebas previas)
    expect(find.byType(ProjectSelectorPage), findsOneWidget);
    await tester.tap(
      find.byKey(
        const ValueKey(
          'project-selector-custom-card-775b0b55-f08e-486b-9e92-fa52ad1b446d',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Activar el formulario (botón inferior "Registrar entrega")
    expect(find.text('Registrar entrega'), findsOneWidget);
    await tester.tap(find.text('Registrar entrega'));
    await tester.pumpAndSettle();

    // ====== SOLO 2 CAMPOS ======
    // 1) Canastillas
    final basketsField = find.byKey(
      const ValueKey('stage4-page-form-returnBaskets-input'),
    );
    await tester.scrollUntilVisible(
      basketsField,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.enterText(basketsField, '5'); // ejemplo
    await tester.pumpAndSettle();

    // 2) Tarros de Cal
    final limeJarsField = find.byKey(
      const ValueKey('stage4-page-form-returnLimeJars-input'),
    );
    await tester.scrollUntilVisible(
      limeJarsField,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.enterText(limeJarsField, '2'); // ejemplo
    await tester.pumpAndSettle();

    // Guardar (botón inferior cambia a "Guardar")
    expect(find.text('Guardar'), findsOneWidget);
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    // Éxito: snackbar y vuelve a desactivar el form (botón vuelve a "Registrar entrega")
    expect(find.text('Entrega registrada'), findsOneWidget);
    expect(find.text('Registrar entrega'), findsOneWidget);
  });
}
