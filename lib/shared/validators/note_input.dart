import 'package:formz/formz.dart';

enum NoteInputError { tooLong }

class NoteInput extends FormzInput<String, NoteInputError> {
  const NoteInput.pure() : super.pure('');
  const NoteInput.dirty([super.value = '']) : super.dirty();

  @override
  NoteInputError? validator(String value) {
    if (value.length > 500) return NoteInputError.tooLong;
    return null;
  }
}
