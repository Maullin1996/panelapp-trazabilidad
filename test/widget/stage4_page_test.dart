import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/stage4_page.dart';
import 'package:registro_panela/features/stage4_recollection/providers/sync_stage4_data_provider.dart';

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

Stage4FormData _return() {
  return Stage4FormData(
    id: 'r1',
    projectId: 'p1',
    date: DateTime(2024, 1, 2),
    returnedGaveras: const [ReturnedGaveras(quantity: 1, referenceWeight: 950)],
    returnedBaskets: 3,
    returnedPreservativesJars: 1,
    returnedLimeJars: 1,
  );
}

void main() {
  testWidgets('Stage4Page shows sections and toggles form', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage4DataProvider.overrideWith((ref) => [_return()]),
        ],
        child: const MaterialApp(home: Stage4Page(projectId: 'p1')),
      ),
    );

    expect(find.text('Gaveras'), findsOneWidget);
    expect(find.text('Canastillas'), findsOneWidget);
    expect(find.text('Tarros de conservantes'), findsOneWidget);
    expect(find.text('Tarros de Cal'), findsOneWidget);

    await tester.tap(find.text('Registrar entrega'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('stage4-page-form-950.0-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage4-page-form-returnBaskets-input')),
      findsOneWidget,
    );
  });
}
