part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapCreated extends MapEvent {
  const MapCreated(this.controller);
  final GoogleMapController controller;

  @override
  List<Object> get props => [controller];
}

final class MapInitiated extends MapEvent {
  const MapInitiated(this.context, this.center);//, this.userMeetingIds);

  final BuildContext context;
  final LatLng center;
  // final List<String> userMeetingIds;

  @override
  List<Object> get props => [context, center];
}

final class MapMarkerListened extends MapEvent {
  const MapMarkerListened(this.meetings);
  final Map<String, Meeting> meetings;

  @override
  List<Object> get props => [meetings];
}

final class _MapMarkerFetched extends MapEvent {
  const _MapMarkerFetched(this.markers);
  final Map<String, MarkerState> markers;

  @override
  List<Object> get props => [markers];
}

final class MapMarkerUpdated extends MapEvent {
  const MapMarkerUpdated(this.userMeetings);
  final List<UserMeeting> userMeetings;

  @override
  List<Object> get props => [userMeetings];
}

final class MapMarkerAddedCenter extends MapEvent {}

final class MapMarkerRemovedCenter extends MapEvent {}

final class MapMovedCenter extends MapEvent {
  const MapMovedCenter(this.position);
  final CameraPosition position;

  @override
  List<Object> get props => [position];
}

final class MapMovedCurrentLatLng extends MapEvent {}

final class MapFilteredMeeting extends MapEvent {
  const MapFilteredMeeting(this.category);
  final MeetingCategory category;

  @override
  List<Object> get props => [category];
}


