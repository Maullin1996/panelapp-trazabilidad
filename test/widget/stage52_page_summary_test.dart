import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';

import 'package:registro_panela/features/stage5_3_summary/presentation/pages/web_stage53_summary_page.dart';

Stage52RecordData _record() => Stage52RecordData(
  id: 'r1',
  projectId: 'p1',
  gaveraWeight: 950,
  panelaWeight: 12,
  unitCount: 3,
  quality: BasketQuality.regular,
  photoPath: '',
  date: DateTime(2024, 1, 1),
);

void main() {
  testWidgets('WebStage52SummaryPage muestra detalles del registro', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncStage52LoadsProvider.overrideWith((ref) => [_record()]),
        ],
        child: const MaterialApp(
          home: WebStage53SummaryPage(projectId: 'p1', recordId: 'r1'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Detalle del registro'.toUpperCase()), findsOneWidget);
  });

  testWidgets(
    'WebStage52SummaryPage muestra indicador de carga cuando no existe el registro',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [syncStage52LoadsProvider.overrideWith((ref) => const [])],
          child: const MaterialApp(
            home: WebStage53SummaryPage(projectId: 'p1', recordId: 'r1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
