part of 'map_bloc.dart';

enum MapStatus {
  initial, // 초기상태
  loading, // mapController 로딩중
  loaded, // mapController 로딩 완료
  selected, // 지도에서 모임 만들기 위치 찾기
  error, // 에러
}

class MarkerState{ // extends Equatable {
  const MarkerState({
    required this.marker,
    this.hostImageUrl,   
    this.iconColor,  
    this.isLoading = true,
  });

  final Marker marker;
  final String? hostImageUrl;
  final IconColors? iconColor;
  final bool isLoading;

  MarkerState copyWith({
    Marker? marker,
    String? hostImageUrl,
    IconColors? iconColor,
    bool? isLoading,
  }) {
    return MarkerState(
      marker: marker ?? this.marker,
      hostImageUrl: hostImageUrl ?? this.hostImageUrl,
      iconColor: iconColor ?? this.iconColor,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  // @override
  // List<Object?> get props => [marker, hostImageUrl, iconColor, isLoading];
}

final class MapState {
  // extends Equatable {
  const MapState({
    this.status = MapStatus.initial,
    this.mapController,
    this.center,
    this.markers = const {},
    this.category = MeetingCategory.all,
    this.errorMessage,
  });

  final MapStatus status;
  final GoogleMapController? mapController;
  final LatLng? center;
  final Map<String, MarkerState> markers;
  final MeetingCategory category; // 필터에서 쓸 카테고리
  final String? errorMessage;

  /*
   속성에 null 값도 넣을 수 있게 Funtion()으로 만듬
   ex) state.copyWith(errorMessage: null)이면 state에 있던 errorMessage 그대로 복사하고
       state.copyWith(errorMessage: () => null)이면 errorMessage = null이 됨
  */
  MapState copyWith({
    MapStatus? status,
    GoogleMapController? mapController,
    LatLng? Function()? center,
    Map<String, MarkerState>? markers,
    MeetingCategory? category,
    String? Function()? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      mapController: mapController ?? this.mapController,
      center: center != null ? center() : this.center,
      markers: markers ?? this.markers,
      category: category ?? this.category,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  // @override
  // List<Object?> get props => [status, mapController, center, markers, category, errorMessage];
}
