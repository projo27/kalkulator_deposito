import 'package:intl/intl.dart';

class NumberConversion {
  static String toCurrency(
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

  static String decimal(num value) {
    return NumberFormat.percentPattern('id').format(value);
  }
}
