import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:registro_panela/features/project_selector/presentation/project_selector_page.dart';
import 'package:registro_panela/main.dart' as app;
import 'package:registro_panela/shared/widgets/camera_preview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'stage5: abrir Summary y operar MissingWeight (abono=200, precio=400)',
    (tester) async {
      app.main();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Login (rol liquidación)
      await tester.enterText(
        find.byKey(const ValueKey('login-email-input')),
        'liquidacion@panelera.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('login-password-input')),
        '123456789',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('login-message')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('login-enter-button')));
      await tester.pumpAndSettle();

      // Ir al proyecto
      expect(find.byType(ProjectSelectorPage), findsOneWidget);
      await tester.tap(
        find.byKey(
          const ValueKey(
            'project-selector-custom-card-775b0b55-f08e-486b-9e92-fa52ad1b446d',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // --- Parte 1: Stage5Summary (ya estás en el tab 0) ---
      final inSummary =
          find.text('No ha habido cargues').evaluate().isNotEmpty ||
          find.text('Resumen general').evaluate().isNotEmpty ||
          find.text('Resumen Diario').evaluate().isNotEmpty;
      expect(inSummary, isTrue);

      // --- Parte 2: Stage5MissingWeight (tab "Reporte") ---
      await tester.tap(
        find.byKey(ValueKey('stage52-page-reporte-botton')),
      ); // cambia al índice 1
      await tester.pumpAndSettle();

      // Abrir formulario de "Realizar Abono"
      final addInstallmentBtn = find.byKey(
        const ValueKey('stage5-form-total-to-pay-add-installment-button'),
      );
      expect(addInstallmentBtn, findsOneWidget);
      await tester.tap(addInstallmentBtn);
      await tester.pumpAndSettle();

      // Input de abono = 200
      final installmentInput = find.byKey(
        const ValueKey('stage5-form-total-to-pay-add-installment-input'),
      );
      await tester.scrollUntilVisible(
        installmentInput,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.enterText(installmentInput, '200');
      await tester.pumpAndSettle();

      // Drag leve para evitar que el teclado tape el botón
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
      await tester.pumpAndSettle();

      // Guardar abono
      final saveInstallmentBtn = find.byKey(
        const ValueKey('stage5-form-total-to-pay-save-button'),
      );
      await tester.scrollUntilVisible(
        saveInstallmentBtn,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(saveInstallmentBtn);
      await tester.pumpAndSettle();

      // Precio por kilo = 400
      final priceInput = find.byKey(
        const ValueKey('stage5-form-total-to-pay-price-input'),
      );
      await tester.scrollUntilVisible(
        priceInput,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.enterText(priceInput, '400');
      await tester.pumpAndSettle();

      // Drag leve para despejar teclado
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
      await tester.pumpAndSettle();

      // Calcular
      final calcBtn = find.byKey(
        const ValueKey('stage5-form-total-to-pay-calculate-button'),
      );
      await tester.scrollUntilVisible(
        calcBtn,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(calcBtn);
      // esperar la animación de scroll de 400 ms + setState
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Aparece el resumen de factura
      expect(find.text('Resumen de factura'), findsOneWidget);

      // --- Parte 3: Stage52Page + Form (tab "Entrega") ---
      await tester.tap(
        find.byKey(ValueKey('stage52-page-entrega-botton')),
      ); // cambia al índice 2
      await tester.pumpAndSettle();

      // Botón "Nuevo registro"
      final newRecordBtn = find.byKey(
        const ValueKey('stage52-page-form-button'),
      );
      expect(newRecordBtn, findsOneWidget);
      await tester.tap(newRecordBtn);
      await tester.pumpAndSettle();

      // ====== Completar formulario ======

      // 1) Gavera (dropdown) -> selecciona el primer ítem disponible
      final gaveraDropdown = find.byKey(
        const ValueKey('stage52-form-gavera-input'),
      );
      await tester.scrollUntilVisible(
        gaveraDropdown,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(gaveraDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('stage52-form-gavera-950.0')));
      await tester.pumpAndSettle();

      // 2) Peso de panela (kg)
      final panelaWeight = find.byKey(
        const ValueKey('stage52-form-panela-weight-input'),
      );
      await tester.scrollUntilVisible(
        panelaWeight,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(panelaWeight, '12.5');
      await tester.pumpAndSettle();

      // 3) Unidades de panela
      final units = find.byKey(
        const ValueKey('stage52-form-panela-unit-input'),
      );
      await tester.scrollUntilVisible(
        units,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(units, '24');
      await tester.pumpAndSettle();

      // 4) Calidad (dropdown) -> intenta 'buena', si no existe toma el primero
      final qualityDropdown = find.byKey(
        const ValueKey('stage52-form-quality-input'),
      );
      await tester.scrollUntilVisible(
        qualityDropdown,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(qualityDropdown);
      await tester.pumpAndSettle();
      final buenaOpt = find.byKey(const ValueKey('stage52-form-quality-buena'));
      if (buenaOpt.evaluate().isNotEmpty) {
        await tester.tap(buenaOpt);
      } else {
        await tester.tap(find.byType(DropdownMenuItem).first);
      }
      await tester.pumpAndSettle();

      // 5) Foto -> Cámara -> tomar y confirmar
      final photoBtn = find.byKey(const ValueKey('stage52-form-photo-button'));
      await tester.scrollUntilVisible(
        photoBtn,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(photoBtn);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('stage52-form-camera-button')),
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

      // 6) Guardar registro
      final submitBtn = find.byKey(
        const ValueKey('stage52-form-submmit-button'),
      );
      await tester.scrollUntilVisible(
        submitBtn,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();
    },
  );
}
