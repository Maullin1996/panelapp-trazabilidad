import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/stage1_page.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';

Stage1FormData _project({String id = 'p1', String name = 'Molienda'}) {
  return Stage1FormData(
    id: id,
    name: name,
    gaveras: const [GaveraData(quantity: 2, referenceWeight: 950)],
    basketsQuantity: 10,
    preservativesWeight: 1,
    preservativesJars: 1,
    limeWeight: 1,
    limeJars: 1,
    phone: '1234567',
    date: DateTime(2024, 1, 1),
  );
}

void main() {
  testWidgets('Stage1Page shows new project title and form fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Stage1Page(projectId: 'new')),
      ),
    );

    expect(find.text('Nuevo proyecto'), findsOneWidget);
    expect(
      find.byKey(const Key('stage1-load-form-molienda-name-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-add-gaveras-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-baskets-quantity')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage1-load-form-phone-input')),
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
        ],
        child: const MaterialApp(home: Stage1Page(projectId: 'p1')),
      ),
    );

    expect(find.text('Modificar Molienda'), findsOneWidget);
  });
}
