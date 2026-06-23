import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/inventory/providers/inventory_providers.dart';

import '../../apps/web/lib/feature/stage1/mobile_stage1_page.dart';

Stage1FormData _project({String id = 'p1', String name = 'Molienda'}) {
  return Stage1FormData(
    id: id,
    name: name,
    gaveras: const [GaveraData(quantity: 2, referenceWeight: 950)],
    baskets: const [],
    preservativesWeight: 1,
    preservativesJars: 1,
    limeWeight: 1,
    limeJars: 1,
    phone: '1234567',
    date: DateTime(2024, 1, 1),
  );
}

_baseOverrides({Stage1FormData? project}) => [
  stage1ProjectByIdProvider.overrideWith((ref, id) => project),
  syncInventoryItemsProvider.overrideWith((ref) => const []),
];

void main() {
  testWidgets('Stage1Page shows new project title and key form elements', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(),
        child: const MaterialApp(home: Stage1Page(projectId: 'new')),
      ),
    );
    await tester.pump();

    expect(find.text('Nuevo proyecto'.toUpperCase()), findsOneWidget);
    expect(
      find.byKey(const Key('stage1-load-form-molienda-dropdown')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-add-gaveras-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-summit-button')),
      findsOneWidget,
    );
  });

  testWidgets('Stage1Page shows edit title when project exists', (
    tester,
  ) async {
    final project = _project();
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(project: project),
        child: const MaterialApp(home: Stage1Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    expect(find.text('Modificar Molienda'.toUpperCase()), findsOneWidget);
  });
}
