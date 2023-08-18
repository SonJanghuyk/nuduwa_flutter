part of 'map_bloc.dart';

enum MapStatus {
  initial,
  loading,
  loaded,
  selected,
  creted,
  error,
}

final class MapState extends Equatable {
  const MapState({
    required this.status,
    this.mapController,
    this.center,
    this.errorMessage,
  });

  final MapStatus status;
  final GoogleMapController? mapController;
  final LatLng? center;
  final String? errorMessage;

  const MapState.initial() : this(status: MapStatus.initial);

  MapState copyWith({
    MapStatus? status,
    GoogleMapController? mapController,
    LatLng? center,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      mapController: mapController ?? this.mapController,
      center: center ?? this.center,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, mapController, center, errorMessage];
}

