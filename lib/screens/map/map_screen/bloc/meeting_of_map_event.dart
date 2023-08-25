part of 'meeting_of_map_bloc.dart';

sealed class MeetingOfMapEvent extends Equatable {
  const MeetingOfMapEvent();

  @override
  List<Object> get props => [];
}
final class _MeetingOfMapListened extends MeetingOfMapEvent { 
  const _MeetingOfMapListened(this.meetings);
  final List<Meeting> meetings;

  @override
  List<Object> get props => [meetings];
}

final class MeetingOfMapFetched extends MeetingOfMapEvent { 
  const MeetingOfMapFetched(this.meetings);
  final Map<String, Meeting> meetings;

  @override
  List<Object> get props => [meetings];
}

final class _MeetingOfMapErrored extends MeetingOfMapEvent { 
  const _MeetingOfMapErrored(this.errorHandle);
  final dynamic errorHandle;

  @override
  List<Object> get props => [errorHandle];
}

final class MeetingOfMapPaused extends MeetingOfMapEvent {}


final class MeetingOfMapResumed extends MeetingOfMapEvent {}


final class MeetingOfMapUpdated extends MeetingOfMapEvent {  
  const MeetingOfMapUpdated(this.userMeetings);
  final List<UserMeeting> userMeetings;

  @override
  List<Object> get props => [userMeetings];
}






