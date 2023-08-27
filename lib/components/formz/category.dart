import 'package:formz/formz.dart';
import 'package:nuduwa_flutter/models/meeting.dart';

class CategoryInput extends FormzInput<MeetingCategory, String> {
  const CategoryInput.pure() : super.pure(MeetingCategory.all);

  const CategoryInput.dirty(MeetingCategory value) : super.dirty(value);
  
  @override
  String? validator(MeetingCategory value) {
    if (value == MeetingCategory.all) {
      return '입력해주세요';
    }
    return null;
  }  
}