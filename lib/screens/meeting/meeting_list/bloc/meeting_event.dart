part of 'meeting_bloc.dart';

sealed class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object?> get props => [];
}

final class _MeetingFetchedHostData extends MeetingEvent {
  const _MeetingFetchedHostData(this.hostUid);

  final String hostUid;

  @override
  List<Object> get props => [hostUid];
}

final class _MeetingFetchedMeeting extends MeetingEvent {
  const _MeetingFetchedMeeting(this.meeting);

  final Meeting? meeting;

  @override
  List<Object?> get props => [meeting];
}

final class MeetingResumed extends MeetingEvent { }
final class MeetingPaused extends MeetingEvent { }
