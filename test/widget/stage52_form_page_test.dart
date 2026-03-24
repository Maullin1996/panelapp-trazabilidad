import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/stage52_form_page.dart';
import 'package:registro_panela/features/stage5_2_records/providers/sync_stage52_loads_provider.dart';

Stage1FormData _project() {
  return Stage1FormData(
    id: 'p1',
    name: 'Project',
    gaveras: const [
      GaveraData(quantity: 3, referenceWeight: 950),
    ],
    basketsQuantity: 10,
    preservativesWeight: 1,
    preservativesJars: 1,
    limeWeight: 1,
    limeJars: 1,
    phone: '123',
    date: DateTime(2024, 1, 1),
  );
}

Stage52RecordData _record() {
  return Stage52RecordData(
    id: 'r1',
    projectId: 'p1',
    gaveraWeight: 950,
    panelaWeight: 9,
    unitCount: 2,
    quality: BasketQuality.regular,
    photoPath: 'http://img',
    date: DateTime(2024, 1, 1),
  );
}

void main() {
  testWidgets('Stage52FormPage shows new record title and fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage52LoadsProvider.overrideWith((ref) => const []),
        ],
        child: const MaterialApp(
          home: Stage52FormPage(projectId: 'p1'),
        ),
      ),
    );

    expect(find.text('Nuevo registro de panela'), findsOneWidget);
    expect(find.byKey(const Key('stage52-form-gavera-input')), findsOneWidget);
    expect(find.byKey(const Key('stage52-form-panela-weight-input')), findsOneWidget);
    expect(find.byKey(const Key('stage52-form-panela-unit-input')), findsOneWidget);
    expect(find.byKey(const Key('stage52-form-quality-input')), findsOneWidget);
    expect(find.byKey(const Key('stage52-form-photo-button')), findsOneWidget);
    expect(find.byKey(const Key('stage52-form-submmit-button')), findsOneWidget);
  });

  testWidgets('Stage52FormPage shows edit title when id is provided', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
          syncStage52LoadsProvider.overrideWith((ref) => [_record()]),
        ],
        child: const MaterialApp(
          home: Stage52FormPage(projectId: 'p1', id: 'r1'),
        ),
      ),
    );

    expect(find.text('Editar registro de panela'), findsOneWidget);
  });
}