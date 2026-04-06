import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/stage2_page.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_loads_error_provider.dart';

Stage1FormData _project() {
  return Stage1FormData(
    id: 'p1',
    name: 'Molienda',
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

Stage2LoadData _load() {
  return Stage2LoadData(
    id: 'l1',
    projectId: 'p1',
    date: DateTime(2024, 1, 2),
    baskets: const BasketLoadData(
      referenceWeight: 950,
      count: 5,
      realWeight: 12,
    ),
  );
}

void main() {
  testWidgets('Stage2Page shows empty state and create button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => const []),
          stage2LoadsErrorProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );

    expect(find.text('Aún no hay cargues registrados'), findsOneWidget);
    expect(
      find.byKey(const Key('stage2-page-create-load-button')),
      findsOneWidget,
    );
  });

  testWidgets('Stage2Page renders a load card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load()]),
          stage2LoadsErrorProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(home: Stage2Page(projectId: 'p1')),
      ),
    );

    expect(
      find.byKey(const Key('stage2-page-load-custom-card-l1')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('stage2_page_12.0-weight')), findsOneWidget);

    await tester.tap(find.byKey(const Key('stage2-page-load-custom-card-l1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('stage2-page-edit-textbutton')),
      findsOneWidget,
    );
  });
}
