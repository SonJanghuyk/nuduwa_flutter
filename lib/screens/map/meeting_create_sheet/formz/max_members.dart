import 'package:formz/formz.dart';

class MaxMembersInput extends FormzInput<int, String> {
  const MaxMembersInput.pure() : super.pure(1);

  const MaxMembersInput.dirty(int value) : super.dirty(value);
  
  @override
  String? validator(int value) {
    if (value == 0) {
      return '최대 인원수를 정해주세요';
    }

    return null;
  }  
}