import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/widgets/form_total_to_pay.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/sync_stage51_payments_provider.dart';

Finder _richTextContaining(String text) {
  return find.byWidgetPredicate((widget) {
    if (widget is! RichText) return false;
    final span = widget.text;
    if (span is! TextSpan) return false;
    final children = span.children ?? const <InlineSpan>[];
    return children.whereType<TextSpan>().any((c) => c.text?.contains(text) ?? false);
  });
}

void main() {
  testWidgets('FormTotalToPay calculates and shows summary', (tester) async {
    final controller = ScrollController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncStage51PaymentsProvider.overrideWith(
            (ref) => <PaymentData>[],
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: FormTotalToPay(
                projectId: 'p1',
                totalRegisteredWeight: 10,
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('stage5-form-total-to-pay-price-input')),
      '1000',
    );

    await tester.tap(
      find.byKey(const Key('stage5-form-total-to-pay-calculate-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Resumen de factura'), findsOneWidget);
    expect(_richTextContaining('Total a pagar:'), findsOneWidget);
    expect(_richTextContaining('Peso registrado:'), findsOneWidget);
  });
}