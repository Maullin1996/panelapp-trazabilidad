import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/providers/sync_stage4_data_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/stage5_missing_weight.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/sync_stage51_payments_provider.dart';

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
  testWidgets('Stage5MissingWeight shows totals and installment section', (
    tester,
  ) async {
    final payment = PaymentData(
      id: 'pay1',
      projectId: 'p1',
      date: DateTime(2024, 1, 2),
      amount: 5000,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
          syncStage3ProjectsProvider.overrideWith((ref) => [_entry()]),
          syncStage4DataProvider.overrideWith((ref) => [_return()]),
          syncStage51PaymentsProvider.overrideWith((ref) => [payment]),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Stage5MissingWeight(projectId: 'p1')),
        ),
      ),
    );

    expect(find.text('Total registrado en moliendas'), findsOneWidget);
    expect(find.text('Total registrado en bodega'), findsOneWidget);
    expect(find.text('Total Faltante'), findsOneWidget);
    expect(find.text('Abonos realizados'), findsOneWidget);
  });
}
