import 'package:intl/intl.dart';

String moneyFormat(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'eu',
    customPattern: '#,###\u00a4',
    symbol: '',
  );
  return formatter.format(amount);
}
