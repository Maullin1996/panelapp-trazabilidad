import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage5_summary/presentation/stage5_summary.dart';

Stage2LoadData _load({
  required String id,
  required DateTime date,
  required double ref,
  required double real,
  required int count,
}) {
  return Stage2LoadData(
    id: id,
    projectId: 'p1',
    date: date,
    baskets: BasketLoadData(
      referenceWeight: ref,
      count: count,
      realWeight: real,
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
  });

  testWidgets('Stage5Summary shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [syncStage2ProjectsProvider.overrideWith((ref) => const [])],
        child: const MaterialApp(home: Stage5Summary(projectId: 'p1')),
      ),
    );

    expect(find.text('No ha habido cargues'), findsOneWidget);
  });

  testWidgets('Stage5Summary renders global and daily summaries', (
    tester,
  ) async {
    final loads = [
      _load(
        id: 'a',
        date: DateTime(2024, 1, 1, 10),
        ref: 950,
        real: 12,
        count: 5,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [syncStage2ProjectsProvider.overrideWith((ref) => loads)],
        child: const MaterialApp(home: Stage5Summary(projectId: 'p1')),
      ),
    );

    expect(find.text('Resumen general'), findsOneWidget);
    expect(find.text('Resumen Diario'), findsOneWidget);
    expect(find.textContaining('Canastillas:'), findsWidgets);
  });
}
