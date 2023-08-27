import 'package:formz/formz.dart';

class TitleInput extends FormzInput<String, String> {
  const TitleInput.pure() : super.pure('');

  const TitleInput.dirty(String value) : super.dirty(value);
  
  @override
  String? validator(String value) {
    if (value.length < 2) {
      return '2글자이상 입력해주세요';
    }

    return null;
  }  
}