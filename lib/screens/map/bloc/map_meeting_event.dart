part of 'map_meeting_bloc.dart';

sealed class MapMeetingEvent extends Equatable {
  const MapMeetingEvent();

  @override
  List<Object> get props => [];
}


final class _MapMeetingStarted extends MapMeetingEvent { 
  @override
  List<Object> get props => [];
}

final class _MapMeetingFetched extends MapMeetingEvent { 
  const _MapMeetingFetched(this.meetingMarkers);
  final Set<Marker> meetingMarkers;

  @override
  List<Object> get props => [meetingMarkers];
}

final class MapMeetingUpdated extends MapMeetingEvent {  
  const MapMeetingUpdated(this.userMeetings);
  final List<UserMeeting> userMeetings;

  @override
  List<Object> get props => [userMeetings];
}
