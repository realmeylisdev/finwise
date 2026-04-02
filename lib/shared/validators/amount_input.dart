import 'package:formz/formz.dart';

enum AmountInputError { empty, invalid, negative, tooLarge }

class AmountInput extends FormzInput<String, AmountInputError> {
  const AmountInput.pure() : super.pure('');
  const AmountInput.dirty([super.value = '']) : super.dirty();

  static const double _maxAmount = 999999999;

  @override
  AmountInputError? validator(String value) {
    if (value.isEmpty) return AmountInputError.empty;
    final parsed = double.tryParse(value);
    if (parsed == null) return AmountInputError.invalid;
    if (parsed <= 0) return AmountInputError.negative;
    if (parsed > _maxAmount) return AmountInputError.tooLarge;
    return null;
  }
}
