import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/stage52_page_summary.dart';

Finder _richTextContaining(String text) {
  return find.byWidgetPredicate((widget) {
    if (widget is! RichText) return false;
    final span = widget.text;
    if (span is! TextSpan) return false;
    final children = span.children ?? const <InlineSpan>[];
    return children.whereType<TextSpan>().any(
      (c) => c.text?.contains(text) ?? false,
    );
  });
}

Stage52RecordData _record() {
  return Stage52RecordData(
    id: 'r1',
    projectId: 'p1',
    gaveraWeight: 950,
    panelaWeight: 12,
    unitCount: 3,
    quality: BasketQuality.regular,
    photoPath: 'http://img',
    date: DateTime(2024, 1, 1),
  );
}

void main() {
  testWidgets('Stage52SummaryPage shows record details', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncStage52LoadsProvider.overrideWith((ref) => [_record()]),
        ],
        child: const MaterialApp(
          home: Stage52SummaryPage(projectId: 'p1', recordId: 'r1'),
        ),
      ),
    );

    expect(find.text('Detalle del registro'), findsOneWidget);
    expect(_richTextContaining('Gavera usada:'), findsOneWidget);
    expect(_richTextContaining('Peso panela:'), findsOneWidget);
    expect(_richTextContaining('Unidades  de panela:'), findsOneWidget);
    expect(_richTextContaining('Calidad:'), findsOneWidget);
  });
}
