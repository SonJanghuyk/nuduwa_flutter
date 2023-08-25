import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nuduwa_flutter/repository/user_meeting_repository.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

part 'user_meeting_event.dart';
part 'user_meeting_state.dart';

class UserMeetingBloc extends Bloc<UserMeetingEvent, UserMeetingState> {
  UserMeetingBloc({required UserMeetingRepository userMeetingRepository})
      : _userMeetingRepository = userMeetingRepository,
        super(const UserMeetingState()) {
    on<UserMeetingResumed>(_onResumed);
    on<_UserMeetingFetched>(_onFetched);
    on<UserMeetingPaused>(_onPaused);

    _userMeetingsSubscription = _userMeetingRepository.userMeetings.listen(
      (userMeetings) => add(_UserMeetingFetched(userMeetings)),
    );
  }

  final UserMeetingRepository _userMeetingRepository;
  late final StreamSubscription<List<UserMeeting>> _userMeetingsSubscription;

  void _onFetched(_UserMeetingFetched event, Emitter<UserMeetingState> emit) {
    debugPrint('유저미팅: ${event.userMeetings.length}');
    emit(state.copyWith(
      status: UserMeetingStatus.stream,
      userMeetings: event.userMeetings,
    ));
  }

  void _onResumed(UserMeetingResumed event, Emitter<UserMeetingState> emit) {
    _userMeetingsSubscription.resume();
  }

  void _onPaused(UserMeetingPaused event, Emitter<UserMeetingState> emit) {
    _userMeetingsSubscription.pause();
    emit(state.copyWith(status: UserMeetingStatus.pause));
  }

  @override
  Future<void> close() {
    _userMeetingsSubscription.cancel();
    return super.close();
  }
}
