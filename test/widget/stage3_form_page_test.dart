import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/stage3_form_page.dart';
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
      count: 1,
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
    baskets: const [],
  );
}

void main() {
  testWidgets('Stage3FormPage shows new title and fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
          syncStage3ProjectsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(
          home: Stage3FormPage(projectId: 'p1', load2Id: 'l1'),
        ),
      ),
    );

    expect(find.text('Registrar pesaje'), findsOneWidget);
    expect(find.byKey(const Key('stage3-load-form-realWeight0-input')), findsOneWidget);
    expect(find.byKey(const Key('stage3-load-form-quality0-input')), findsOneWidget);
    expect(find.byKey(const Key('stage3-load-form-image0-button')), findsOneWidget);
    expect(find.byKey(const Key('stage3-load-form-submmit-button')), findsOneWidget);
  });

  testWidgets('Stage3FormPage shows edit title when entry exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
          syncStage3ProjectsProvider.overrideWith((ref) => [_entry()]),
        ],
        child: const MaterialApp(
          home: Stage3FormPage(projectId: 'p1', load2Id: 'l1'),
        ),
      ),
    );

    expect(find.text('Editar pesaje'), findsOneWidget);
  });
}