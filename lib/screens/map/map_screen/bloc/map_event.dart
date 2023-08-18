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

final class MapInitiatedCenter extends MapEvent {
  const MapInitiatedCenter(this.center);
  final LatLng center;

  @override
  List<Object> get props => [center];
}

final class MapSelectedNewMeetingLocation extends MapEvent {}

final class MapCanceledNewMeetingLocation extends MapEvent {}

final class MapCreatedNewMeeting extends MapEvent {}

final class MapMovedCenter extends MapEvent {
  const MapMovedCenter(this.position);
  final CameraPosition position;

  @override
  List<Object> get props => [position];
}

final class MapMovedCurrentLatLng extends MapEvent {}

