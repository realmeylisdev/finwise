import 'package:formz/formz.dart';

enum NameInputError { empty, tooShort, tooLong }

class NameInput extends FormzInput<String, NameInputError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameInputError? validator(String value) {
    if (value.isEmpty) return NameInputError.empty;
    if (value.length < 2) return NameInputError.tooShort;
    if (value.length > 100) return NameInputError.tooLong;
    return null;
  }
}
