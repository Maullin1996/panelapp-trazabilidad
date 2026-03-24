import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';

void main() {
  testWidgets('CustomRichText shows icon and two text spans', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomRichText(
            firstText: 'Label: ',
            secondText: 'Value',
            icon: Icons.info,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.info), findsOneWidget);

    final richTextFinder = find.byWidgetPredicate((widget) {
      if (widget is! RichText) return false;
      final text = widget.text;
      if (text is! TextSpan) return false;
      final children = text.children;
      if (children == null || children.length != 2) return false;
      final first = children[0] as TextSpan;
      final second = children[1] as TextSpan;
      return first.text == 'Label: ' && second.text == 'Value';
    });

    expect(richTextFinder, findsOneWidget);
  });

  testWidgets('CustomRichText renders without an icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomRichText(
            firstText: 'Hello ',
            secondText: 'World',
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsNothing);

    final richTextFinder = find.byWidgetPredicate((widget) {
      if (widget is! RichText) return false;
      final text = widget.text;
      if (text is! TextSpan) return false;
      final children = text.children;
      if (children == null || children.length != 2) return false;
      final first = children[0] as TextSpan;
      final second = children[1] as TextSpan;
      return first.text == 'Hello ' && second.text == 'World';
    });

    expect(richTextFinder, findsOneWidget);
  });
}