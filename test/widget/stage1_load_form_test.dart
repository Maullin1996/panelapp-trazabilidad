import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/features/inventory/providers/inventory_providers.dart';

import '../../apps/web/lib/feature/stage1/mobile_stage1_form.dart';

void main() {
  testWidgets('Stage1LoadForm shows structural buttons with empty inventory', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncInventoryItemsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Stage1LoadForm(isNew: true),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const Key('stage1-load-form-add-gaveras-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-add-baskets-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-molienda-dropdown')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-summit-button')),
      findsOneWidget,
    );
  });

  testWidgets(
    'Stage1LoadForm shows empty-inventory message when no gaveras in stock',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            syncInventoryItemsProvider.overrideWith((ref) => const []),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Stage1LoadForm(isNew: true),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text('No hay gaveras en el inventario'),
        findsOneWidget,
      );
      expect(
        find.text('No hay canastillas en el inventario'),
        findsOneWidget,
      );
    },
  );
}
