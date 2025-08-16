import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/project_selector/presentation/project_selector_page.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/stage3_page.dart';
import 'package:registro_panela/main.dart' as app;
import 'package:registro_panela/shared/widgets/camera_preview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("flujo de etapa 3 'pesaje'", (tester) async {
    app.main();
    await tester.pump(); // primer frame
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 👉 Aquí deberías loguear con un usuario válido (por ejemplo molienda@panelera.com)
    await tester.enterText(
      find.byKey(ValueKey("login-email-input")),
      'pesado@panelera.com',
    );
    await tester.enterText(
      find.byKey(ValueKey("login-password-input")),
      '123456789',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('login-message')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('login-enter-button')));
    await tester.pumpAndSettle();

    // 👉 Navegas al proyecto (ya creado en Stage1)
    expect(find.byType(ProjectSelectorPage), findsOneWidget);
    await tester.tap(
      find.byKey(
        ValueKey(
          'project-selector-custom-card-775b0b55-f08e-486b-9e92-fa52ad1b446d',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 👉 Ya estás en Stage3Page, asegúrate de que aparece el card
    final cardFinder = find.byKey(
      ValueKey('stage3-page-8c53457a-0c67-4e65-82f1-656087e1431d-custom-card'),
    );
    expect(cardFinder, findsOneWidget);

    // 👉 Tocar el CustomCard para abrir el diálogo
    await tester.tap(cardFinder);
    await tester.pumpAndSettle();

    // 👉 Verificar que el diálogo tiene el botón de continuar formulario
    final formButton = find.byKey(ValueKey('stage3-page-form-button'));
    expect(formButton, findsOneWidget);
    await tester.tap(formButton);
    await tester.pumpAndSettle();

    // 👉 Ahora estás en Stage3LoadForm
    expect(
      find.byKey(ValueKey('stage3-load-form-realWeight0-input')),
      findsWidgets,
    );

    // 👉 Escribir peso y calidad en la primera canastilla
    await tester.enterText(
      find.byKey(ValueKey('stage3-load-form-realWeight0-input')),
      '24.5',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ValueKey('stage3-load-form-quality0-input')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('stage3-load-form-buena-input')));
    await tester.pumpAndSettle();

    // 👉 Subir foto
    await tester.tap(find.byKey(ValueKey('stage3-load-form-image0-button')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ValueKey('stage3-load-form-take-photo-button')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CameraPreviewScreen), findsOne);

    // 👉 Simular tomar foto
    await tester.tap(find.byKey(ValueKey('camera-preview-screen-take-photo')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ValueKey('camera-preview-screen-confirme-photo')),
    );
    await tester.pumpAndSettle();

    // 👉 Confirmar envío
    await tester.tap(find.byKey(ValueKey('stage3-load-form-submmit-button')));
    await tester.pumpAndSettle();

    // 👉 Aquí podrías verificar que vuelve a Stage3Page
    expect(find.byType(Stage3Page), findsOneWidget);
  });
}
