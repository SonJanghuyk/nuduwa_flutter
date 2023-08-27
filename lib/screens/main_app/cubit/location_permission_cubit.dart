import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

part 'location_permission_state.dart';

class LocationPermissionCubit extends Cubit<LocationPermissionState> {
  LocationPermissionCubit() : super(const LocationPermissionState.initial()){
    _checkLocationPermission();
    debugPrint('LocationPermissionCubit시작');
  }

  void _checkLocationPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    // 위치 서비스 활성화 여부 확인
    if (!isLocationEnabled) {
      // 위치 서비스 활성화 안됨
      emit(state.copyWith(status: LocationPermissionStatus.error, errorMessage: '위치 서비스 꺼져 있음'));
      return;
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    //위치 권한 확인
    if (checkedPermission == LocationPermission.denied) {
      // 위치 권한 거절 상태
      // 위치 권한 요청하기
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        emit(state.copyWith(status: LocationPermissionStatus.denied,  errorMessage: '위치 정보가 필요합니다'));
        return ;
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      // 위치 권한 거절됨 (앱에서 재요청 불가)
      emit(state.copyWith(status: LocationPermissionStatus.error, errorMessage: '더 이상 위치 권한 요청 불가'));
      return;
    }

    final currentPosition = await Geolocator.getCurrentPosition();
    final currentLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    emit(state.copyWith(status: LocationPermissionStatus.enabled, currentLatLng: currentLatLng));
  }

  @override
  Future<void> close() {
    debugPrint('LocationPermissionCubit끝');
    return super.close();
  }
}