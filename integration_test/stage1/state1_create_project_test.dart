import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/auth/presentation/login_page.dart';
import 'package:registro_panela/features/project_selector/presentation/project_selector_page.dart';
import 'package:registro_panela/features/splash/splash_screen.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/stage1_page.dart';
import 'package:registro_panela/main.dart' as app;
import 'package:registro_panela/shared/widgets/camera_preview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Crear un proyecto desde el role de entrega', () {
    testWidgets("flujo de etapa 1 'entrega'", (tester) async {
      app.main();
      // Evita esperar infinito:
      await tester.pump(); // primer frame
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);

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
      expect(find.byType(ProjectSelectorPage), findsOneWidget);
      await tester.tap(
        find.byKey(ValueKey('project-selector-create-project-button')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Stage1Page), findsOneWidget);
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-molienda-name-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-molienda-name-input')),
        'Don jose',
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-gavera-quantity-input0')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-gavera-quantity-input0')),
        '10',
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-gavera-weight-input0')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-gavera-weight-input0')),
        '950',
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-add-gaveras-button')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(ValueKey('stage1-load-form-gavera-weight-input1')),
        findsOne,
      );
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-remove-gaveras-button1')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(ValueKey('stage1-load-form-gavera-weight-input1')),
        findsNothing,
      );
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-gavera-weight-input0')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-baskets-quantity')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-baskets-quantity')),
        '120',
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-baskets-quantity')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-preservativesWeight-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-preservativesWeight-input')),
        '1.5',
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-preservativesJars-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-preservativesJars-input')),
        '2',
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-preservativesJars-input')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('stage1-load-form-limeWeight-input')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-limeWeight-input')),
        '1.5',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage1-load-form-limeJars-input')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-limeJars-input')),
        '2',
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-limeJars-input')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage1-load-form-phone-input')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(ValueKey('stage1-load-form-phone-input')),
        '3111111111',
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-phone-input')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage1-load-form-photo-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey("stage1-load-form-camera-button")));
      await tester.pumpAndSettle();
      expect(find.byType(CameraPreviewScreen), findsOne);
      await tester.tap(
        find.byKey(ValueKey('camera-preview-screen-take-photo')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(ValueKey('camera-preview-screen-confirme-photo')),
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(ValueKey('stage1-load-form-phone-input')),
        const Offset(0, -700),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(ValueKey('stage1-load-form-image')), findsOne);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage1-load-form-summit-button')));
      await tester.pumpAndSettle();
    });
  });
}
