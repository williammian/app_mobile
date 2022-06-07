import 'package:intl/intl.dart';

class Utils {
  static String formatCurrency(num value, {int fractionDigits = 2}) {
    return NumberFormat.currency(
            locale: 'pt_BR', symbol: '', decimalDigits: fractionDigits)
        .format(value);
  }

  static num parseCurrency(String value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: '').parse(value);
  }
}
