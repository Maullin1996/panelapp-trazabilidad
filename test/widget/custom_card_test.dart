import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../packages/core/lib/shared/utils/colors.dart';
import '../../packages/core/lib/shared/utils/radius.dart';
import '../../packages/core/lib/shared/widgets/custom_card.dart';

void main() {
  testWidgets('CustomCard renders with default styling', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CustomCard(child: Text('Card child'))),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, AppColors.cardBackground);

    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(AppRadius.large));
    expect(find.text('Card child'), findsOneWidget);
  });

  testWidgets('CustomCard uses provided selection color', (tester) async {
    const selected = Colors.red;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomCard(isSelected: selected, child: Text('Selected card')),
        ),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, selected);
  });
}
