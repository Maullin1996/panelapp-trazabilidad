import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/index.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/pages/stage5_summary.dart';

Stage2LoadData _load({
  required String id,
  required DateTime date,
  required double ref,
  required int count,
}) {
  return Stage2LoadData(
    id: id,
    projectId: 'p1',
    date: date,
    baskets: BasketLoadData(
      referenceWeight: ref,
      count: count,
      quality: BasketQuality.buena,
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
  });

  testWidgets('Stage5Summary muestra EmptyWidget sin cargues', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncStage2ProjectsProvider.overrideWith((ref) => const []),
          syncStage3ProjectsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Stage5Summary(projectId: 'p1')),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(EmptyWidget), findsOneWidget);
  });

  testWidgets('Stage5Summary renderiza resumen global y diario con cargues', (
    tester,
  ) async {
    final loads = [
      _load(id: 'a', date: DateTime(2024, 1, 1, 10), ref: 950, count: 5),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncStage2ProjectsProvider.overrideWith((ref) => loads),
          syncStage3ProjectsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Stage5Summary(projectId: 'p1')),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Total acumulado'), findsOneWidget);
    expect(find.text('Resumen diario'), findsOneWidget);
  });
}
