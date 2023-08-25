import 'package:formz/formz.dart';
import 'package:nuduwa_flutter/models/meeting.dart';

class CategoryInput extends FormzInput<String, String> {
  const CategoryInput.pure() : super.pure('');

  const CategoryInput.dirty(String value) : super.dirty(value);
  
  @override
  String? validator(String value) {
    if (value == '') {
      return '입력해주세요';
    } else if (!MeetingCategory.values.map((e) => e.category).contains(value)) {
      return '오류';
    }

    return null;
  }  
}