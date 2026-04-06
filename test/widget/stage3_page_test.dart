import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_loads_by_id_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/stage3_page.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';

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

Stage2LoadData _load2() {
  return Stage2LoadData(
    id: 'l1',
    projectId: 'p1',
    date: DateTime(2024, 1, 2),
    baskets: const BasketLoadData(
      referenceWeight: 950,
      count: 2,
      realWeight: 12,
    ),
  );
}

Stage3FormData _entry() {
  return Stage3FormData(
    id: 's1',
    projectId: 'p1',
    stage2LoadId: 'l1',
    date: DateTime(2024, 1, 3),
    baskets: const [
      BasketWeighData(
        id: 'b1',
        sequence: 0,
        referenceWeight: 950,
        realWeight: 11,
        quality: BasketQuality.regular,
        photoPath: '',
      ),
    ],
  );
}

void main() {
  testWidgets('Stage3Page shows empty state when no loads', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(home: Stage3Page(projectId: 'p1')),
      ),
    );

    expect(find.text('Todavía no se han realizado cargues'), findsOneWidget);
  });

  testWidgets('Stage3Page renders load card and dialog without summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
          stage2LoadsByIdProvider.overrideWith((ref, id) => _load2()),
          syncStage3ProjectsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(home: Stage3Page(projectId: 'p1')),
      ),
    );

    expect(find.byKey(const Key('stage3-page-l1-custom-card')), findsOneWidget);

    await tester.tap(find.byKey(const Key('stage3-page-l1-custom-card')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stage3-page-form-button')), findsOneWidget);
    expect(find.byKey(const Key('stage3-page-summery-button')), findsNothing);
  });

  testWidgets('Stage3Page shows summary option when entry exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
          stage2LoadsByIdProvider.overrideWith((ref, id) => _load2()),
          syncStage3ProjectsProvider.overrideWith((ref) => [_entry()]),
        ],
        child: const MaterialApp(home: Stage3Page(projectId: 'p1')),
      ),
    );

    await tester.tap(find.byKey(const Key('stage3-page-l1-custom-card')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stage3-page-summery-button')), findsOneWidget);
  });
}
