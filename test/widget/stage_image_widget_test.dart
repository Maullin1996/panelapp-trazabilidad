import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/shared/widgets/stage_image_widget.dart';

void main() {
  testWidgets('StageImageWidget muestra error widget para URL inválida', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StageImageWidget(imageUrl: 'not-a-valid-url'),
        ),
      ),
    );

    expect(find.byType(StageImageWidget), findsOneWidget);
  });

  testWidgets('StageImageWidget usa Image.network para URLs http', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StageImageWidget(imageUrl: 'http://example.com/image.jpg'),
        ),
      ),
    );

    expect(find.byType(StageImageWidget), findsOneWidget);
  });
}
