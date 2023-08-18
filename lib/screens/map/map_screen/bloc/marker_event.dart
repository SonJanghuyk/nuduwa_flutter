part of 'marker_bloc.dart';

sealed class MarkerEvent extends Equatable {
  const MarkerEvent();

  @override
  List<Object> get props => [];
}

final class _MarkerStarted extends MarkerEvent { 
  @override
  List<Object> get props => [];
}

final class _MarkerFetched extends MarkerEvent { 
  const _MarkerFetched(this.markers);
  final Set<Marker> markers;

  @override
  List<Object> get props => [markers];
}

final class MarkerUpdated extends MarkerEvent {  
  const MarkerUpdated(this.userMeetings);
  final List<UserMeeting> userMeetings;

  @override
  List<Object> get props => [userMeetings];
}

final class MarkerAddedCenter extends MarkerEvent {
  const MarkerAddedCenter(this.center);

  final LatLng center;

  @override
  List<Object> get props => [center];
}
final class MarkerRemovedCenter extends MarkerEvent {

  @override
  List<Object> get props => [];
}






