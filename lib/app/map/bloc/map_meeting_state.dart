part of 'map_meeting_bloc.dart';

enum MapMeetingStatus {
  initial,
  loading,
  loaded,
  error,
}

final class MapMeetingState extends Equatable {
  const MapMeetingState({
    required this.status,
    this.meetingMarkers = const {},
    this.errorMessage,
  });

  final MapMeetingStatus status;
  final Set<Marker> meetingMarkers;
  final String? errorMessage;


  const MapMeetingState.initial() : this(status: MapMeetingStatus.initial);

  MapMeetingState copyWith({
    MapMeetingStatus? status,
    Set<Marker>? meetingMarkers,
    String? errorMessage,
  }) {
    return MapMeetingState(
      status: status ?? this.status,
      meetingMarkers: meetingMarkers ?? this.meetingMarkers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, meetingMarkers, errorMessage];
}

