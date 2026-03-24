import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/providers/sync_stage4_data_provider.dart';
import 'package:registro_panela/features/stage5/presentation/stage5_page.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/sync_stage51_payments_provider.dart';
import 'package:registro_panela/features/stage5_2_records/providers/sync_stage52_loads_provider.dart';

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

Stage4FormData _return() {
  return Stage4FormData(
    id: 'r1',
    projectId: 'p1',
    date: DateTime(2024, 1, 2),
    returnedGaveras: const [ReturnedGaveras(quantity: 1, referenceWeight: 950)],
    returnedBaskets: 3,
    returnedPreservativesJars: 0,
    returnedLimeJars: 0,
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
  });

  testWidgets('Stage5Page shows bottom nav and switches tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
          syncStage3ProjectsProvider.overrideWith((ref) => [_entry()]),
          syncStage4DataProvider.overrideWith((ref) => [_return()]),
          syncStage51PaymentsProvider.overrideWith((ref) => const []),
          syncStage52LoadsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(home: Stage5Page(projectId: 'p1')),
      ),
    );

    expect(find.byKey(const Key('stage52-page-resumen-botton')), findsOneWidget);
    expect(find.byKey(const Key('stage52-page-reporte-botton')), findsOneWidget);
    expect(find.byKey(const Key('stage52-page-entrega-botton')), findsOneWidget);

    await tester.tap(find.text('Reporte'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Total registrado en moliendas'), findsWidgets);
  });
}