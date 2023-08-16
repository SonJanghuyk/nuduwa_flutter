part of 'user_meeting_bloc.dart';

sealed class UserMeetingEvent extends Equatable {
  const UserMeetingEvent();

  @override
  List<Object> get props => [];
}

final class UserMeetingResumed extends UserMeetingEvent { 

  @override
  List<Object> get props => [];
}

final class _UserMeetingFetched extends UserMeetingEvent { 
  const _UserMeetingFetched(this.userMeetings);
  final List<UserMeeting> userMeetings;

  @override
  List<Object> get props => [];
}

final class UserMeetingPaused extends UserMeetingEvent {  

  @override
  List<Object> get props => [];
}

final class UserMeetingCreated extends UserMeetingEvent {  
  const UserMeetingCreated(this.meeting);
  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

final class UserMeetingJoined extends UserMeetingEvent {  
  const UserMeetingJoined(this.meeting);
  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

final class UserMeetingLeft extends UserMeetingEvent {  
  const UserMeetingLeft(this.meeting);
  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

