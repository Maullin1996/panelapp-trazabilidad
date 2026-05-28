import 'package:flutter/services.dart';

class CommaToDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final fixed = newValue.text.replaceAll(',', '.');

    // (Opcional) permitir solo un punto
    final first = fixed.indexOf('.');
    String singleDot = fixed;
    if (first != -1) {
      singleDot =
          fixed.substring(0, first + 1) +
          fixed.substring(first + 1).replaceAll('.', '');
    }

    return newValue.copyWith(
      text: singleDot,
      selection: TextSelection.collapsed(offset: singleDot.length),
    );
  }
}
