import 'package:intl/intl.dart';

class NumberConversion {
  static toCurrency(
    num value, {
    int decimalDigit = 0,
  }) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    ).format(value);
  }
}
