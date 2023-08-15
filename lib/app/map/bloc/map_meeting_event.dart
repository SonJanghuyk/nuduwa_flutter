part of 'map_meeting_bloc.dart';

sealed class MapMeetingEvent extends Equatable {
  const MapMeetingEvent();

  @override
  List<Object> get props => [];
}

final class _MapMeetingFetched extends MapMeetingEvent { 
  const _MapMeetingFetched(this.meetings);
  final List<Meeting> meetings;

  @override
  List<Object> get props => [meetings];
}

final class MapMeetingCreated extends MapMeetingEvent {  
  const MapMeetingCreated(this.meeting);
  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

final class MapMeetingJoined extends MapMeetingEvent {  
  const MapMeetingJoined(this.meeting);
  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

final class MapMeetingLeft extends MapMeetingEvent {  
  const MapMeetingLeft(this.meeting);
  final Meeting meeting;

  @override
  List<Object> get props => [meeting];
}

