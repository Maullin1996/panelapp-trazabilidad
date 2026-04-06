import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_summary_provider.dart';

Stage2LoadData _load({
  required String id,
  required String projectId,
  required DateTime date,
  required double ref,
  required double real,
  required int count,
}) {
  return Stage2LoadData(
    id: id,
    projectId: projectId,
    date: date,
    baskets: BasketLoadData(
      referenceWeight: ref,
      count: count,
      realWeight: real,
    ),
  );
}

void main() {
  test('stage5Summary groups by day and aggregates counts', () {
    final loads = [
      _load(
        id: 'a',
        projectId: 'p1',
        date: DateTime(2024, 1, 1, 10),
        ref: 28,
        real: 950,
        count: 10,
      ),
      _load(
        id: 'b',
        projectId: 'p1',
        date: DateTime(2024, 1, 1, 15),
        ref: 28,
        real: 950,
        count: 5,
      ),
      _load(
        id: 'c',
        projectId: 'p1',
        date: DateTime(2024, 1, 2, 9),
        ref: 30,
        real: 980,
        count: 7,
      ),
      _load(
        id: 'd',
        projectId: 'other',
        date: DateTime(2024, 1, 1, 10),
        ref: 28,
        real: 950,
        count: 100,
      ),
    ];

    final container = ProviderContainer(
      overrides: [syncStage2ProjectsProvider.overrideWith((ref) => loads)],
    );
    addTearDown(container.dispose);

    final summary = container.read(stage5SummaryProvider('p1'));

    expect(summary.length, 2);
    expect(summary.first.date, DateTime(2024, 1, 1));
    expect(summary.last.date, DateTime(2024, 1, 2));

    final day1Items = summary.first.items;
    expect(day1Items.length, 1);
    expect(day1Items.first.gaveraWeight, 28);
    expect(day1Items.first.realWeight, 950);
    expect(day1Items.first.totalCount, 15);
  });

  test('stage5Summary sorts items by realWeight', () {
    final loads = [
      _load(
        id: 'a',
        projectId: 'p1',
        date: DateTime(2024, 1, 1, 10),
        ref: 28,
        real: 1000,
        count: 1,
      ),
      _load(
        id: 'b',
        projectId: 'p1',
        date: DateTime(2024, 1, 1, 10),
        ref: 28,
        real: 900,
        count: 1,
      ),
    ];

    final container = ProviderContainer(
      overrides: [syncStage2ProjectsProvider.overrideWith((ref) => loads)],
    );
    addTearDown(container.dispose);

    final summary = container.read(stage5SummaryProvider('p1'));
    final items = summary.first.items;

    expect(items.first.realWeight, 900);
    expect(items.last.realWeight, 1000);
  });
}
