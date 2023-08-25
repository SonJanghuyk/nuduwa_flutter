import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/components/utils/map_helper.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';
import 'package:nuduwa_flutter/screens/map/meeting_info_sheet/meeting_info_sheet.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required MapHelper mapHelper})
      : _mapHelper = mapHelper,
        super(const MapState()) {
    on<MapInitiatedCenter>(_onInitiatedCenter);
    on<MapCreated>(_onMapCreated);
    on<MapMarkerListened>(_onMarkerListened);
    on<_MapMarkerFetched>(_onMarkerFetched);
    on<MapMarkerUpdated>(_onMarkerUpdated);
    on<MapMarkerAddedCenter>(_onMarkerAddedCenter);
    on<MapMarkerRemovedCenter>(_onMarkerRemovedCenter);
    // on<MapCreatedNewMeeting>(_onCreatedMeeting);
    on<MapMovedCenter>(_onMovedCenter);
    on<MapMovedCurrentLatLng>(_onMovedCurrentLatLng);
    on<MapFilteredMeeting>(_onFiltered);
  }

  late BuildContext _context;
  late LatLng _center;
  final MapHelper _mapHelper;
  List<String> _userMeetingIds = [];

  final newMarkerId = 'NewMarker';

  void _onInitiatedCenter(MapInitiatedCenter event, Emitter<MapState> emit) {
    _context = event.context;
    _center = event.center;
  }

  void _onMapCreated(MapCreated event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    final mapStyle = await rootBundle.loadString(Assets.txtGoogleMapStyle);
    final controller = event.controller;
    controller.setMapStyle(mapStyle);
    emit(state.copyWith(status: MapStatus.loaded, mapController: controller));
  }

  void _onMarkerListened(
      MapMarkerListened event, Emitter<MapState> emit) async {
    if (!_mapHelper.isInit) {
      await _mapHelper.initializeVariables();
    }
    final preMarkers = state.markers;

    final newMarkers = event.meetings.map((meetingId, meeting) {
      // 이전에 만들어놓은 마커 있으면 그대로 쓰고
      final markerState = preMarkers[meetingId];
      if (markerState != null) {
        if (markerState.hostImageUrl == null && meeting.hostImageUrl != null) {
          return MapEntry(meetingId,
              markerState.copyWith(hostImageUrl: meeting.hostImageUrl));
        }
        return MapEntry(meetingId, markerState);
      }

      // 없으면 임시로 새로 만들기
      final iconColor = _iconColor(meetingId, meeting.hostUid);
      final newMarker = _mapHelper.creatLoadingMarker(
          meeting: meeting,
          iconColor: iconColor,
          onTap: () => meetingInfoSheet(_context, meetingId));
      final newMarkerState = MarkerState(
        marker: newMarker,
        hostImageUrl: meeting.hostImageUrl,
        iconColor: iconColor,
        isLoading: true,
      );
      return MapEntry(meetingId, newMarkerState);
    });
    add(_MapMarkerFetched(newMarkers));

    // 마커에 HostImage 넣기
    newMarkers.forEach((meetingId, markerState) {
      if (markerState.isLoading == false) return;
      if (markerState.hostImageUrl == null) return;

      _mapHelper
          .fetchMeetingMarker(
        markerState: markerState,
      )
          .then((newMarker) {
        final markers = state.markers;
        final newMarkerState = markerState.copyWith(
          marker: newMarker,
          isLoading: false,
        );
        markers[meetingId] = newMarkerState;
        add(_MapMarkerFetched(markers));
      });
    });
  }

  IconColors _iconColor(String? meetingId, String hostUid) {
    if (hostUid == FirebaseAuth.instance.currentUser?.uid) {
      // host일때
      return IconColors.host;
    } else if (_userMeetingIds.contains(meetingId)) {
      // 참여중인 모임일때
      return IconColors.join;
    }
    // 둘다 아닐때
    return IconColors.defalt;
  }

  void _onMarkerFetched(_MapMarkerFetched event, Emitter<MapState> emit) {
    final markers = Map<String, MarkerState>.from(event.markers);
    emit(state.copyWith(markers: markers));
  }

  void _onMarkerUpdated(MapMarkerUpdated event, Emitter<MapState> emit) {
    final userMeetings = event.userMeetings;
    final markers = state.markers;

    _userMeetingIds = userMeetings.map((e) => e.id!).toList();

    markers.forEach((key, value) {
      final bool conditionA = _userMeetingIds.contains(key);
      final bool conditionB = value.iconColor == IconColors.defalt;
      if ((conditionA && conditionB) || (!conditionA && !conditionB)) {
        final iconColor = _iconColor(
            key, userMeetings.firstWhere((e) => e.meetingId == key).hostUid);

        if (value.hostImageUrl == null) {
          final newMarker = value.marker.copyWith(
            iconParam: _mapHelper.loadingIcon(iconColor),
          );
          final markers = state.markers;
          markers[key] =
              value.copyWith(marker: newMarker, iconColor: iconColor, isLoading: true);
          add(_MapMarkerFetched(markers));
        } else {
          _mapHelper
              .fetchMeetingMarker(
            markerState: value,
          )
              .then((newMarker) {
            final newMarkerState = value.copyWith(
              marker: newMarker,
              iconColor: iconColor,
              isLoading: false,
            );
            final markers = state.markers;
            markers[key] = newMarkerState;
            add(_MapMarkerFetched(markers));
          });
        }
      }
    });
  }

  void _onMarkerAddedCenter(
      MapMarkerAddedCenter event, Emitter<MapState> emit) {
    final markers = state.markers;
    final newMarkerState = markers[newMarkerId];
    late final Marker newMarker;

    if (newMarkerState != null) {
      newMarker = newMarkerState.marker.copyWith(
        positionParam: _center,
      );
      markers[newMarkerId] = newMarkerState.copyWith(marker: newMarker);
    } else {
      newMarker = Marker(
        markerId: MarkerId(newMarkerId),
        position: _center,
        zIndex: 1,
      );
      markers[newMarkerId] = MarkerState(marker: newMarker, iconColor: null);
    }

    emit(state.copyWith(
        status: MapStatus.selected, center: () => _center, markers: markers));
  }

  void _onMarkerRemovedCenter(
      MapMarkerRemovedCenter event, Emitter<MapState> emit) {
    final markers = state.markers;
    markers.remove(newMarkerId);

    emit(state.copyWith(
        status: MapStatus.loaded, center: () => null, markers: markers));
  }

  // void _onCreatedMeeting(MapCreatedNewMeeting event, Emitter<MapState> emit) {
  //   emit(state.copyWith(status: MapStatus.loaded));
  // }

  void _onMovedCenter(MapMovedCenter event, Emitter<MapState> emit) {
    // final LatLng center = event.position.target;
    // emit(state.copyWith(center: center));
    _center = event.position.target;
    if (state.status == MapStatus.selected) {
      add(MapMarkerAddedCenter());
    }
  }

  void _onMovedCurrentLatLng(
      MapMovedCurrentLatLng event, Emitter<MapState> emit) async {
    final currentPosition = await Geolocator.getCurrentPosition();
    final controller = state.mapController;
    controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 15.0,
      ),
    ));
    emit(state.copyWith(mapController: controller));
  }

  void _onFiltered(MapFilteredMeeting event, Emitter<MapState> emit) {
    if (state.category == event.category) return;
    emit(state.copyWith(category: event.category));
  }
}
