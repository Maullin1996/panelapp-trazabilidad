import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/stage2_loads_by_id_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/stage3_page_summary.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';

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
  testWidgets('Stage3PageSummary shows unavailable message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          stage2LoadsByIdProvider.overrideWith((ref, id) => _load2()),
          syncStage3ProjectsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(
          home: Stage3PageSummary(projectId: 'p1', load2Id: 'l1'),
        ),
      ),
    );

    expect(find.text('Resumen no disponible'), findsOneWidget);
  });

  testWidgets('Stage3PageSummary renders summary sections', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          stage2LoadsByIdProvider.overrideWith((ref, id) => _load2()),
          syncStage3ProjectsProvider.overrideWith((ref) => [_entry()]),
        ],
        child: const MaterialApp(
          home: Stage3PageSummary(projectId: 'p1', load2Id: 'l1'),
        ),
      ),
    );

    expect(find.text('Registrado en molienda'), findsOneWidget);
    expect(find.text('Registrado en bodega'), findsOneWidget);
    expect(find.text('Faltantes'), findsOneWidget);
    expect(find.text('Detalle por canastilla'), findsOneWidget);
    expect(find.textContaining('Canastilla #1'), findsOneWidget);
  });
}
