import 'package:formz/formz.dart';

class PlaceInput extends FormzInput<String, String> {
  const PlaceInput.pure() : super.pure('');

  const PlaceInput.dirty(String value) : super.dirty(value);
  
  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return '1글자이상 입력해주세요';
    }

    return null;
  }  
}