import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  MeetingBloc(
      {required MeetingRepository meetingRepository,
      required UserMeeting userMeeting})
      : meetingId = userMeeting.meetingId,
        _meetingRepository = meetingRepository,
        super(const MeetingState()) {
    on<_MeetingFetchedHostData>(_onFetchedHostData);
    on<_MeetingFetchedMeeting>(_onFetchedMeeting);
    on<MeetingResumed>(_onResumed);
    on<MeetingPaused>(_onPaused);

    add(_MeetingFetchedHostData(userMeeting.hostUid));

    _meetingSubscription =
        _meetingRepository.meeting(userMeeting.meetingId).listen(
              (meeting) => add(_MeetingFetchedMeeting(meeting)),
            );
            debugPrint('MeetingBloc시작');
  }

  final String meetingId;
  final MeetingRepository _meetingRepository;
  late final StreamSubscription<Meeting?> _meetingSubscription;
  ({String? image, String? name})? _hostData;

  void _onFetchedHostData(
      _MeetingFetchedHostData event, Emitter<MeetingState> emit) async {
    final hostUid = event.hostUid;

    final hostData = await _meetingRepository.getUserNameAndImage(hostUid);
    _hostData = hostData;

    final meeting = state.meeting;
    if (meeting == null) return;

    meeting.hostName = hostData.name;
    meeting.hostImageUrl = hostData.image;

    debugPrint('host1: $_hostData');

    emit(state.copyWith(meeting: meeting));
  }

  void _onFetchedMeeting(
      _MeetingFetchedMeeting event, Emitter<MeetingState> emit) {
    final meeting = event.meeting;
    meeting?.hostName = _hostData?.name;
    meeting?.hostImageUrl = _hostData?.image;

    debugPrint('host2: $_hostData');

    emit(state.copyWith(status: MeetingStatus.stream, meeting: meeting));
  }

  void _onResumed(MeetingResumed event, Emitter<MeetingState> emit) {
    _meetingSubscription.resume();
  }

  void _onPaused(MeetingPaused event, Emitter<MeetingState> emit) {
    _meetingSubscription.pause();
    emit(state.copyWith(status: MeetingStatus.pause));
  }

  @override
  Future<void> close() {
    debugPrint('MeetingBloc끝');
    _meetingSubscription.cancel();
    return super.close();
  }
}