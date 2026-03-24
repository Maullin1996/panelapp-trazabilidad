import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/widgets/stage1_load_form.dart';

void main() {
  testWidgets('Stage1LoadForm can add a gavera row', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Stage1LoadForm(isNew: true),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('stage1-load-form-add-gaveras-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('stage1-load-form-add-gaveras-button')));
    await tester.pump();

    expect(find.byKey(const Key('stage1-load-form-remove-gaveras-button1')), findsOneWidget);
  });
}