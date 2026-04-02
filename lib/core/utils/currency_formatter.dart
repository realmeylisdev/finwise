import 'package:intl/intl.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    double amount, {
    required String symbol,
    int decimalPlaces = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    );
    return formatter.format(amount);
  }

  static String formatCompact(
    double amount, {
    required String symbol,
  }) {
    final formatter = NumberFormat.compactCurrency(symbol: symbol);
    return formatter.format(amount);
  }
}
