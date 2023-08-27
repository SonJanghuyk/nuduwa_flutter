import 'package:formz/formz.dart';

class MeetingTimeInput extends FormzInput<DateTime?, String> {
  const MeetingTimeInput.pure() : super.pure(null);

  const MeetingTimeInput.dirty(DateTime value) : super.dirty(value);
  
  @override
  String? validator(DateTime? value) {
    if (value == DateTime(0)) {
      return '미팅시간을 입력해주세요';
    }

    return null;
  }  
}