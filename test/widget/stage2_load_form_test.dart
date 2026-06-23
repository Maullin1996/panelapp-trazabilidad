import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/shared/widgets/stage2_load_form.dart';

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

void main() {
  testWidgets('Stage2LoadForm muestra los campos requeridos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: Stage2LoadForm(project: _project())),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const Key('stage2-load-form-refweight-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage2-load-form-basketsCount-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage2-load-form-quality-input')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('stage2-load-form-summit-button')),
      findsOneWidget,
    );
  });
}
