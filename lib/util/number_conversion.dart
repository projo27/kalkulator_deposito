import 'package:intl/intl.dart';

class NumberConversion {
  static toCurrency(
    num value, {
    int decimalDigit = 0,
    String symbol = 'Rp ',
  }) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: symbol,
      decimalDigits: decimalDigit,
    ).format(value);
  }

  static round(num value) {
    return value.round();
  }
}
