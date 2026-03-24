import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';

void main() {
  testWidgets('StageImageWidget shows error widget for missing local file', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StageImageWidget(imagePath: 'non_existent_file.jpg'),
        ),
      ),
    );

    expect(find.byIcon(Icons.broken_image), findsOneWidget);
  });

  testWidgets('StageImageWidget uses CachedNetworkImage for http URLs', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StageImageWidget(imagePath: 'http://example.com/image.jpg'),
        ),
      ),
    );

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}