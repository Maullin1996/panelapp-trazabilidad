import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_input_formatter.dart';

void main() {
  test('MoneyInputFormatter strips non-digits and formats', () {
    final formatter = MoneyInputFormatter();

    const oldValue = TextEditingValue(text: '');
    const newValue = TextEditingValue(text: '12a34');

    final result = formatter.formatEditUpdate(oldValue, newValue);
    final expected = NumberFormat('#,###', 'eu').format(1234);

    expect(result.text, expected);
    expect(
      result.selection,
      TextSelection.collapsed(offset: expected.length),
    );
  });

  test('MoneyInputFormatter returns empty when no digits', () {
    final formatter = MoneyInputFormatter();

    const oldValue = TextEditingValue(text: '');
    const newValue = TextEditingValue(text: '---');

    final result = formatter.formatEditUpdate(oldValue, newValue);

    expect(result.text, '');
  });
}