part of 'marker_bloc.dart';

enum MarkerStatus {
  initial,
  loading,
  loaded,
  error,
}

final class MarkerState extends Equatable {
  const MarkerState({
    required this.status,
    this.markers = const {},
    this.newMarker,
    this.errorMessage,
  });

  final MarkerStatus status;
  final Set<Marker> markers;
  final Marker? newMarker;
  final String? errorMessage;


  const MarkerState.initial() : this(status: MarkerStatus.initial);

  MarkerState copyWith({
    MarkerStatus? status,
    Set<Marker>? markers,
    Marker? newMarker,
    String? errorMessage,
  }) {
    return MarkerState(
      status: status ?? this.status,
      markers: markers ?? this.markers,
      newMarker: newMarker ?? this.newMarker,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, markers, newMarker, errorMessage];
}


