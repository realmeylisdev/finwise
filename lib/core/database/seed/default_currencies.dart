class DefaultCurrency {
  const DefaultCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    this.decimalPlaces = 2,
  });

  final String code;
  final String name;
  final String symbol;
  final int decimalPlaces;
}

const defaultCurrencies = [
  DefaultCurrency(code: 'USD', name: 'US Dollar', symbol: '\$'),
  DefaultCurrency(code: 'EUR', name: 'Euro', symbol: '€'),
  DefaultCurrency(code: 'GBP', name: 'British Pound', symbol: '£'),
  DefaultCurrency(code: 'TMT', name: 'Turkmen Manat', symbol: 'T'),
  DefaultCurrency(code: 'RUB', name: 'Russian Ruble', symbol: '₽'),
  DefaultCurrency(code: 'TRY', name: 'Turkish Lira', symbol: '₺'),
  DefaultCurrency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
  DefaultCurrency(
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
    decimalPlaces: 0,
  ),
  DefaultCurrency(
    code: 'KRW',
    name: 'South Korean Won',
    symbol: '₩',
    decimalPlaces: 0,
  ),
  DefaultCurrency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ'),
  DefaultCurrency(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
  DefaultCurrency(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$'),
];
