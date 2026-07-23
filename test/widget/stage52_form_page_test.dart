import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';

import 'package:registro_panela/features/stage5_3_summary/presentation/pages/web_stage53_form_page.dart';

Stage1FormData _project() => Stage1FormData(
  id: 'p1',
  name: 'Project',
  gaveras: const [GaveraData(quantity: 3, referenceWeight: 950)],
  baskets: const [],
  preservativesWeight: 1,
  preservativesJars: 1,
  limeWeight: 1,
  limeJars: 1,
  phone: '123',
  date: DateTime(2024, 1, 1),
);

Stage52RecordData _record() => Stage52RecordData(
  id: 'r1',
  projectId: 'p1',
  gaveraWeight: 950,
  panelaWeight: 9,
  unitCount: 2,
  quality: BasketQuality.regular,
  photoPath: '',
  date: DateTime(2024, 1, 1),
);

void main() {
  testWidgets(
    'WebStage52FormPage muestra título de nuevo registro y campos del formulario',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
            syncStage52LoadsProvider.overrideWith((ref) => const []),
          ],
          child: const MaterialApp(home: WebStage53FormPage(projectId: 'p1')),
        ),
      );
      await tester.pump();

      expect(
        find.text('Nuevo registro de panela'.toUpperCase()),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stage52-form-gavera-input')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stage52-form-panela-weight-input')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stage52-form-panela-unit-input')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stage52-form-quality-input')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stage52-form-submmit-button')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'WebStage52FormPage muestra título de editar cuando se provee un id',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stage1ProjectByIdProvider.overrideWith((ref, id) => _project()),
            syncStage52LoadsProvider.overrideWith((ref) => [_record()]),
          ],
          child: const MaterialApp(
            home: WebStage53FormPage(projectId: 'p1', id: 'r1'),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text('Editar registro de panela'.toUpperCase()),
        findsOneWidget,
      );
    },
  );
}
