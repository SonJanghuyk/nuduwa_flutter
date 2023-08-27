import 'package:formz/formz.dart';

class MaxMembersInput extends FormzInput<int, String> {
  const MaxMembersInput.pure() : super.pure(1);

  const MaxMembersInput.dirty(int value) : super.dirty(value);
  
  @override
  String? validator(int value) {
    if (value <= 1) {
      return '최대 인원수는 1명이상으로 설정해주세요';
    }

    return null;
  }  
}