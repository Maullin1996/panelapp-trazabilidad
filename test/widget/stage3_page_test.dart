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
import 'package:core/shared/widgets/empty_widget.dart';

import '../../apps/web/lib/feature/stage3/mobile_stage3_page.dart';

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
    count: 2,
    quality: BasketQuality.buena,
  ),
);

Stage3FormData _entry() => Stage3FormData(
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

_baseOverrides({
  List<Stage2LoadData> loads2 = const [],
  List<Stage3FormData> entries3 = const [],
}) => [
  stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
  syncStage2ProjectsProvider.overrideWith((ref) => loads2),
  stage2ProjectsLoadingProvider.overrideWith((ref) => false),
  syncStage3ProjectsProvider.overrideWith((ref) => entries3),
  stage3LoadsLoadingProvider.overrideWith((ref) => false),
];

void main() {
  testWidgets('Stage3Page muestra EmptyWidget cuando no hay cargues', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(),
        child: const MaterialApp(home: Stage3Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    expect(find.byType(EmptyWidget), findsOneWidget);
  });

  testWidgets(
    'Stage3Page renderiza card del cargue y muestra dialog sin resumen',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _baseOverrides(loads2: [_load2()]),
          child: const MaterialApp(home: Stage3Page(projectId: 'p1')),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const Key('stage3-page-l1-custom-card')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('stage3-page-l1-custom-card')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('stage3-page-form-button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stage3-page-summary-button')),
        findsNothing,
      );
    },
  );

  testWidgets('Stage3Page muestra opción de resumen cuando existe registro', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _baseOverrides(
          loads2: [_load2()],
          entries3: [_entry()],
        ),
        child: const MaterialApp(home: Stage3Page(projectId: 'p1')),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('stage3-page-l1-custom-card')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('stage3-page-summary-button')),
      findsOneWidget,
    );
  });
}
