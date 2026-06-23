import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import 'package:core/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/features/stage3_weigh/providers/index.dart';

import '../../apps/web/lib/feature/stage3/mobile_stage3_form_page.dart';

Stage1FormData _project() => Stage1FormData(
  id: 'p1',
  name: 'Molienda',
  gaveras: const [GaveraData(quantity: 2, referenceWeight: 950)],
  baskets: const [],
  preservativesWeight: 1,
  preservativesJars: 1,
  limeWeight: 1,
  limeJars: 1,
  phone: '1234567',
  date: DateTime(2024, 1, 1),
);

Stage2LoadData _load2() => Stage2LoadData(
  id: 'l1',
  projectId: 'p1',
  date: DateTime(2024, 1, 2),
  baskets: const BasketLoadData(
    referenceWeight: 950,
    count: 1,
    quality: BasketQuality.buena,
  ),
);

Stage3FormData _entry() => Stage3FormData(
  id: 's1',
  projectId: 'p1',
  stage2LoadId: 'l1',
  date: DateTime(2024, 1, 3),
  baskets: const [],
);

_baseOverrides({List<Stage3FormData> entries3 = const []}) => [
  stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
  syncStage2ProjectsProvider.overrideWith((ref) => [_load2()]),
  syncStage3ProjectsProvider.overrideWith((ref) => entries3),
];

void main() {
  testWidgets('Stage3FormPage muestra título y campos para nuevo pesaje', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(),
        child: const MaterialApp(
          home: Stage3FormPage(projectId: 'p1', load2Id: 'l1'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Registrar pesaje'.toUpperCase()), findsOneWidget);
    expect(
      find.byKey(const Key('stage3-load-form-realWeight0-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage3-load-form-quality0-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage3-load-form-image0-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage3-load-form-submmit-button')),
      findsOneWidget,
    );
  });

  testWidgets('Stage3FormPage muestra título de editar cuando existe registro', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(entries3: [_entry()]),
        child: const MaterialApp(
          home: Stage3FormPage(projectId: 'p1', load2Id: 'l1'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Editar pesaje'.toUpperCase()), findsOneWidget);
  });
}
