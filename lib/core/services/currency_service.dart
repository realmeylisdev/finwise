import 'package:injectable/injectable.dart';

@singleton
class CurrencyService {
  /// Hard-coded exchange rates relative to USD.
  /// In the future, these can be fetched via dio from an API.
  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'TMT': 3.50,
    'RUB': 92.0,
    'TRY': 32.0,
    'CNY': 7.24,
    'JPY': 151.0,
    'INR': 83.5,
    'BRL': 5.0,
    'KRW': 1350.0,
    'AED': 3.67,
  };

  /// Convert [amount] from [fromCurrency] to [toCurrency].
  double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    final fromRate = _rates[fromCurrency] ?? 1.0;
    final toRate = _rates[toCurrency] ?? 1.0;
    return amount / fromRate * toRate;
  }

  /// Get the exchange rate from [fromCurrency] to [toCurrency].
  double getRate(String fromCurrency, String toCurrency) {
    final fromRate = _rates[fromCurrency] ?? 1.0;
    final toRate = _rates[toCurrency] ?? 1.0;
    return toRate / fromRate;
  }

  /// List of all supported currency codes.
  List<String> get supportedCurrencies => _rates.keys.toList();

  /// Human-readable symbol for a currency code.
  String getSymbol(String code) {
    const symbols = {
      'USD': '\$',
      'EUR': '\u20AC',
      'GBP': '\u00A3',
      'TMT': 'T',
      'RUB': '\u20BD',
      'TRY': '\u20BA',
      'CNY': '\u00A5',
      'JPY': '\u00A5',
      'INR': '\u20B9',
      'BRL': 'R\$',
      'KRW': '\u20A9',
      'AED': '\u062F.\u0625',
    };
    return symbols[code] ?? code;
  }
}
