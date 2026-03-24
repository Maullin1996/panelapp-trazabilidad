import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/helpers/comma_to_dot_formatter.dart';

void main() {
  test('CommaToDotFormatter replaces commas and keeps a single dot', () {
    final formatter = CommaToDotFormatter();

    const oldValue = TextEditingValue(text: '');
    const newValue = TextEditingValue(text: '12,3.4,5');

    final result = formatter.formatEditUpdate(oldValue, newValue);

    expect(result.text, '12.345');
    expect(result.selection, const TextSelection.collapsed(offset: 6));
  });
}