part of 'location_permission_cubit.dart';

enum LocationPermissionStatus {
  initial,
  enabled,
  denied,
  error,
}


final class LocationPermissionState extends Equatable {
  const LocationPermissionState({
    required this.status,
    this.currentLatLng,
    this.errorMessage,
  });

  final LocationPermissionStatus status;
  final LatLng? currentLatLng;
  final String? errorMessage;

  const LocationPermissionState.initial() : this(status: LocationPermissionStatus.initial);

  LocationPermissionState copyWith({
    LocationPermissionStatus? status,
    LatLng? currentLatLng,
    String? errorMessage,
  }) {
    return LocationPermissionState(
      status: status ?? this.status,
      currentLatLng: currentLatLng ?? this.currentLatLng,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentLatLng, errorMessage];
}
