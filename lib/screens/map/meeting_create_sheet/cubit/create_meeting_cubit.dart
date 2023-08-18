import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/formz/category.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/formz/description.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/formz/max_members.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/formz/meeting_time.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/formz/place.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/formz/title.dart';

part 'create_meeting_state.dart';

class CreateMeetingCubit extends Cubit<CreateMeetingState> {
  CreateMeetingCubit({
    required MeetingRepository meetingRepository,
    required LatLng location,
  })  : _meetingRepository = meetingRepository,
        _location = location,
        super(const CreateMeetingState()) {
    _setInput();
  }

  final MeetingRepository _meetingRepository;
  final LatLng _location;

  void _setInput() {
    final meetingTime = MeetingTimeInput.dirty(DateTime.now());
    emit(
      state.copyWith(
        meetingTime: meetingTime,
        location: _location,
      ),
    );
  }

  void titleChanged(String value) {
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
        ]),
      ),
    );
  }

  void descriptionChanged(String value) {
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
        ]),
      ),
    );
  }

  void placeChanged(String value) {
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
        ]),
      ),
    );
  }

  void maxMembersChanged(int value) {
    final maxMembers = MaxMembersInput.dirty(value);
    emit(
      state.copyWith(
        maxMembers: maxMembers,
        isValid: Formz.validate([
          state.title,
          state.description,
          state.place,
          state.meetingTime,
          maxMembers
        ]),
      ),
    );
  }

  void categoryChanged(String value) {
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

  Future<void> createMeetingFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _meetingRepository.create(
        title: state.title.value,
        description: state.description.value,
        place: state.place.value,
        maxMembers: state.maxMembers.value,
        category: state.category.value,
        location: state.location,
        meetingTime: state.meetingTime.value!,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    }
    // on SignUpWithEmailAndPasswordFailure catch (e) {
    //   emit(
    //     state.copyWith(
    //       errorMessage: e.message,
    //       status: FormzSubmissionStatus.failure,
    //     ),
    //   );
    // }
    catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
