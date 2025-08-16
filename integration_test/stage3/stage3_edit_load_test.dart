import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/project_selector/presentation/project_selector_page.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/stage3_page.dart';
import 'package:registro_panela/main.dart' as app;
import 'package:registro_panela/shared/widgets/camera_preview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("etapa 3: editar formulario existente y llenar index=1", (
    tester,
  ) async {
    app.main();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Login (usuario de pesaje)
    await tester.enterText(
      find.byKey(const ValueKey("login-email-input")),
      'pesado@panelera.com',
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

    // Ir al proyecto ya creado
    expect(find.byType(ProjectSelectorPage), findsOneWidget);
    await tester.tap(
      find.byKey(
        const ValueKey(
          'project-selector-custom-card-775b0b55-f08e-486b-9e92-fa52ad1b446d',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // En Stage3Page, abrir el diálogo del cargue
    final cardFinder = find.byKey(
      const ValueKey(
        'stage3-page-8c53457a-0c67-4e65-82f1-656087e1431d-custom-card',
      ),
    );
    expect(cardFinder, findsOneWidget);
    await tester.tap(cardFinder);
    await tester.pumpAndSettle();

    // Elegir Continuar formulario (edición: inicialData != null)
    final formButton = find.byKey(const ValueKey('stage3-page-form-button'));
    expect(formButton, findsOneWidget);
    await tester.tap(formButton);
    await tester.pumpAndSettle();

    // Asegurar que estamos en el form
    expect(
      find.byKey(const ValueKey('stage3-load-form-submmit-button')),
      findsOneWidget,
    );

    // ====== EDITAR EL SEGUNDO ITEM (index = 1) ======
    // Scrollea hasta el campo de peso real de la canastilla #2
    final realWeight1 = find.byKey(
      const ValueKey('stage3-load-form-realWeight1-input'),
    );
    await tester.scrollUntilVisible(
      realWeight1,
      300, // delta de scroll
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Escribir peso real para index 1
    await tester.enterText(realWeight1, '25.2');
    await tester.pumpAndSettle();

    // Seleccionar calidad para index 1
    final quality1 = find.byKey(
      const ValueKey('stage3-load-form-quality1-input'),
    );
    await tester.tap(quality1);
    await tester.pumpAndSettle();
    // Toca la opción (ajusta el key del item según tus valores, p.e. "buena", "aceptable", etc.)
    await tester.tap(
      find.byKey(const ValueKey('stage3-load-form-buena-input')),
    );
    await tester.pumpAndSettle();

    // Subir foto para index 1
    final imageBtn1 = find.byKey(
      const ValueKey('stage3-load-form-image1-button'),
    );
    await tester.tap(imageBtn1);
    await tester.pumpAndSettle();

    // Elegir tomar foto y confirmar
    await tester.tap(
      find.byKey(const ValueKey('stage3-load-form-take-photo-button')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CameraPreviewScreen), findsOne);

    await tester.tap(
      find.byKey(const ValueKey('camera-preview-screen-take-photo')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('camera-preview-screen-confirme-photo')),
    );
    await tester.pumpAndSettle();

    // (Opcional) Verifica que se muestre la miniatura/imagen cargada del index 1 si tienes un key específico
    // expect(find.byKey(const ValueKey('stage3-load-form-image1-taken')), findsOne);

    // Enviar cambios (editar)
    await tester.tap(
      find.byKey(const ValueKey('stage3-load-form-submmit-button')),
    );
    await tester.pumpAndSettle();

    // Vuelve a la Stage3Page
    expect(find.byType(Stage3Page), findsOneWidget);
  });
}
