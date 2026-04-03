import 'package:finwise/core/services/currency_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CurrencyService currencyService;

  setUp(() {
    currencyService = CurrencyService();
  });

  group('CurrencyService', () {
    group('convert', () {
      test('returns same amount when from and to currencies are the same', () {
        expect(currencyService.convert(100, 'USD', 'USD'), 100);
        expect(currencyService.convert(50.5, 'EUR', 'EUR'), 50.5);
        expect(currencyService.convert(0, 'GBP', 'GBP'), 0);
      });

      test('correctly converts USD to EUR', () {
        // USD rate = 1.0, EUR rate = 0.92
        // 100 USD -> 100 / 1.0 * 0.92 = 92.0 EUR
        final result = currencyService.convert(100, 'USD', 'EUR');
        expect(result, closeTo(92.0, 0.01));
      });

      test('correctly converts EUR to USD', () {
        // EUR rate = 0.92, USD rate = 1.0
        // 100 EUR -> 100 / 0.92 * 1.0 ~= 108.70 USD
        final result = currencyService.convert(100, 'EUR', 'USD');
        expect(result, closeTo(108.70, 0.01));
      });

      test('correctly converts GBP to JPY', () {
        // GBP rate = 0.79, JPY rate = 151.0
        // 100 GBP -> 100 / 0.79 * 151.0 ~= 19113.92
        final result = currencyService.convert(100, 'GBP', 'JPY');
        expect(result, closeTo(19113.92, 0.1));
      });

      test('handles zero amount', () {
        expect(currencyService.convert(0, 'USD', 'EUR'), 0);
      });

      test('uses default rate of 1.0 for unknown currencies', () {
        // Unknown currency falls back to rate 1.0 (same as USD)
        final result = currencyService.convert(100, 'USD', 'XYZ');
        expect(result, closeTo(100.0, 0.01));
      });
    });

    group('getRate', () {
      test('returns 1.0 for same currency', () {
        expect(currencyService.getRate('USD', 'USD'), 1.0);
        expect(currencyService.getRate('EUR', 'EUR'), 1.0);
        expect(currencyService.getRate('JPY', 'JPY'), 1.0);
      });

      test('returns correct rate for USD to EUR', () {
        // toRate / fromRate = 0.92 / 1.0 = 0.92
        expect(currencyService.getRate('USD', 'EUR'), closeTo(0.92, 0.001));
      });

      test('returns correct rate for EUR to USD', () {
        // toRate / fromRate = 1.0 / 0.92 ~= 1.087
        expect(currencyService.getRate('EUR', 'USD'), closeTo(1.087, 0.001));
      });
    });

    group('getSymbol', () {
      test('returns correct symbol for USD', () {
        expect(currencyService.getSymbol('USD'), r'$');
      });

      test('returns correct symbol for EUR', () {
        expect(currencyService.getSymbol('EUR'), '\u20AC');
      });

      test('returns correct symbol for GBP', () {
        expect(currencyService.getSymbol('GBP'), '\u00A3');
      });

      test('returns correct symbol for JPY', () {
        expect(currencyService.getSymbol('JPY'), '\u00A5');
      });

      test('returns correct symbol for TMT', () {
        expect(currencyService.getSymbol('TMT'), 'T');
      });

      test('returns code itself for unknown currency', () {
        expect(currencyService.getSymbol('XYZ'), 'XYZ');
      });
    });

    group('supportedCurrencies', () {
      test('returns non-empty list', () {
        expect(currencyService.supportedCurrencies, isNotEmpty);
      });

      test('contains expected currencies', () {
        final currencies = currencyService.supportedCurrencies;
        expect(currencies, contains('USD'));
        expect(currencies, contains('EUR'));
        expect(currencies, contains('GBP'));
        expect(currencies, contains('TMT'));
        expect(currencies, contains('JPY'));
      });

      test('contains 12 currencies', () {
        expect(currencyService.supportedCurrencies.length, 12);
      });
    });
  });
}
