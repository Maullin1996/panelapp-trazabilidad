import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:registro_panela/features/splash/presentation/web_splash_screen.dart';

void main() {
  testWidgets('WebSplashScreen se renderiza sin errores', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WebSplashScreen()));

    expect(find.byType(WebSplashScreen), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
