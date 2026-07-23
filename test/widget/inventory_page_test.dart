import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:registro_panela/features/inventory/domain/entities/inventory_item.dart';
import 'package:registro_panela/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

import 'package:registro_panela/features/inventory/presentation/pages/mobile_inventory_page.dart';
import 'package:registro_panela/features/inventory/presentation/pages/web_inventory_page.dart';

InventoryItem _gavera() => const InventoryItem(
  id: 'g1',
  type: InventoryItemType.gavera,
  totalUnits: 10,
  availableUnits: 8,
  referenceWeight: 950,
  gaveraType: 'Kilo',
);

InventoryItem _canastilla() => const InventoryItem(
  id: 'c1',
  type: InventoryItemType.canastilla,
  totalUnits: 20,
  availableUnits: 15,
  size: BasketSize.grande,
);

void main() {
  // ── MobileInventoryPage ────────────────────────────────────────────────────────

  group('MobileInventoryPage', () {
    testWidgets('muestra indicador de carga mientras espera datos', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith((ref) => const Stream.empty()),
          ],
          child: const MaterialApp(home: MobileInventoryPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('muestra secciones vacías cuando no hay ítems', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith(
              (ref) => Stream.value(const []),
            ),
          ],
          child: const MaterialApp(home: MobileInventoryPage()),
        ),
      );
      await tester.pump();

      expect(find.text('Sin gaveras registradas'), findsOneWidget);
      expect(find.text('Sin canastillas registradas'), findsOneWidget);
    });

    testWidgets('muestra el título Inventario en la AppBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith(
              (ref) => Stream.value(const []),
            ),
          ],
          child: const MaterialApp(home: MobileInventoryPage()),
        ),
      );
      await tester.pump();

      expect(find.text('Inventario'), findsOneWidget);
    });

    testWidgets('muestra tarjetas cuando hay ítems en el inventario', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith(
              (ref) => Stream.value([_gavera(), _canastilla()]),
            ),
          ],
          child: const MaterialApp(home: MobileInventoryPage()),
        ),
      );
      await tester.pump();

      expect(find.text('950.0 g — Kilo'), findsOneWidget);
      expect(find.text('Grande'), findsOneWidget);
      expect(find.text('Sin gaveras registradas'), findsNothing);
      expect(find.text('Sin canastillas registradas'), findsNothing);
    });
  });

  // ── WebInventoryPage ───────────────────────────────────────────────────────────

  group('WebInventoryPage', () {
    setUp(() {});

    testWidgets('muestra el encabezado Inventario', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith(
              (ref) => Stream.value(const []),
            ),
          ],
          child: const MaterialApp(home: WebInventoryPage()),
        ),
      );
      await tester.pump();

      // The NavigationRail also labels one destination "Inventario",
      // so at least 2 occurrences are expected.
      expect(find.text('Inventario'), findsAtLeastNWidgets(2));
    });

    testWidgets('muestra columnas vacías sin ítems', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith(
              (ref) => Stream.value(const []),
            ),
          ],
          child: const MaterialApp(home: WebInventoryPage()),
        ),
      );
      await tester.pump();

      expect(find.text('Sin gaveras registradas'), findsOneWidget);
      expect(find.text('Sin canastillas registradas'), findsOneWidget);
    });

    testWidgets('muestra ítems en las columnas correspondientes', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inventoryItemsProvider.overrideWith(
              (ref) => Stream.value([_gavera(), _canastilla()]),
            ),
          ],
          child: const MaterialApp(home: WebInventoryPage()),
        ),
      );
      await tester.pump();

      expect(find.text('950.0 g — Kilo'), findsOneWidget);
      expect(find.text('Grande'), findsOneWidget);
    });
  });
}
