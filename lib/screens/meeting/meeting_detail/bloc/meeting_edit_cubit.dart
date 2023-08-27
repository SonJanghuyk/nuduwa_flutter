import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:nuduwa_flutter/components/formz/category.dart';
import 'package:nuduwa_flutter/components/formz/description.dart';
import 'package:nuduwa_flutter/components/formz/max_members.dart';
import 'package:nuduwa_flutter/components/formz/meeting_time.dart';
import 'package:nuduwa_flutter/components/formz/place.dart';
import 'package:nuduwa_flutter/components/formz/title.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';

part 'meeting_edit_state.dart';

class MeetingEditCubit extends Cubit<MeetingEditState> {
  MeetingEditCubit({
    required MeetingRepository meetingRepository,
  })  : _meetingRepository = meetingRepository,
        super(const MeetingEditState()){
          debugPrint('MeetingEditCubit시작');
        }

  final MeetingRepository _meetingRepository;
  late Meeting _meeting;

  void updateMeeting(Meeting? meeting) {
    if (meeting==null) return;
    _meeting = meeting;
  }

  void titleChanged(String value) {
    if(value == _meeting.title) return;
    final title = TitleInput.dirty(value);
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate([
          title,
          state.description,
          state.place,
          state.meetingTime,
          state.maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void descriptionChanged(String value) {
    if(value == _meeting.description) return;
    final description = DescriptionInput.dirty(value);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate([
          state.title,
          description,
          state.place,
          state.meetingTime,
          state.maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void placeChanged(String value) {
    if(value == _meeting.place) return;
    final place = PlaceInput.dirty(value);
    emit(
      state.copyWith(
        place: place,
        isValid: Formz.validate([
          state.title,
          state.description,
          place,
          state.meetingTime,
          state.maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void timeChanged(Future<TimeOfDay?> value) async {
    final newTime = await value;
    if (newTime == null) return;
    final preTime = state.meetingTime.value!;
    final pickTime = DateTime(
        preTime.year, preTime.month, preTime.day, newTime.hour, newTime.minute);

    if(pickTime == _meeting.meetingTime) return;
    final meetingTime = MeetingTimeInput.dirty(pickTime);
    emit(
      state.copyWith(
        meetingTime: meetingTime,
        isValid: Formz.validate([
          state.title,
          state.description,
          state.place,
          meetingTime,
          state.maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void timeChangedtoToday() {
    final preTime = state.meetingTime.value!;
    final today = DateTime.now();
    final pickTime = preTime.copyWith(
      year: today.year,
      month: today.month,
      day: today.day,
    );

    if (preTime == pickTime) return;
    if(pickTime == _meeting.meetingTime) return;

    final meetingTime = MeetingTimeInput.dirty(pickTime);
    emit(
      state.copyWith(
        meetingTime: meetingTime,
        isValid: Formz.validate([
          state.title,
          state.description,
          state.place,
          meetingTime,
          state.maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void timeChangedtoTomorrow() {
    final preTime = state.meetingTime.value!;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final pickTime = preTime.copyWith(
      year: tomorrow.year,
      month: tomorrow.month,
      day: tomorrow.day,
    );

    if (preTime == pickTime) return;
    if(pickTime == _meeting.meetingTime) return;

    final meetingTime = MeetingTimeInput.dirty(pickTime);
    emit(
      state.copyWith(
        meetingTime: meetingTime,
        isValid: Formz.validate([
          state.title,
          state.description,
          state.place,
          meetingTime,
          state.maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void maxMembersChanged(int value) {
    if(value == _meeting.maxMembers) return;
    final maxMembers = MaxMembersInput.dirty(value);
    emit(
      state.copyWith(
        maxMembers: maxMembers,
        isValid: Formz.validate([
          state.title,
          state.description,
          state.place,
          state.meetingTime,
          maxMembers,
          state.category,
        ]),
      ),
    );
  }

  void categoryChanged(MeetingCategory value) {
    if(value == _meeting.category) return;
    final category = CategoryInput.dirty(value);
    emit(
      state.copyWith(
        category: category,
        isValid: Formz.validate([
          state.title,
          state.description,
          state.place,
          state.meetingTime,
          state.maxMembers,
          category,
        ]),
      ),
    );
  }

  @override
  Future<void> close() {
    debugPrint('MeetingEditCubit끝');
    return super.close();
  }
}
