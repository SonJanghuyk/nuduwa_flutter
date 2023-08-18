import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/components/utils/map_helper.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

part 'marker_event.dart';
part 'marker_state.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  MarkerBloc({required MeetingRepository meetingRepository})
      : _meetingRepository = meetingRepository,
        super(const MarkerState.initial()) {
    // on<_MarkerStarted>(_onStarted);
    on<_MarkerFetched>((event, emit) => emit(state.copyWith(
        status: MarkerStatus.loaded, markers: event.markers)));
    on<MarkerUpdated>(_onUpdated);
    on<MarkerAddedCenter>(_onAddedCenter);
    on<MarkerRemovedCenter>(_onRemovedCenter);

    _mapHelper.initializeVariables().then((_) => 
    _meetingsSubscription = _meetingRepository.meetings.listen(
      _onData
    ));
    

    // add(_MarkerStarted());
  }

  final MeetingRepository _meetingRepository;
  late final StreamSubscription<List<Meeting>> _meetingsSubscription;
  final MapHelper _mapHelper = MapHelper(
      drawIconOfMeeting: DrawIconOfMeeting(
    imageSize: !kIsWeb ? 80.0 : 26.666,
    borderWidth: !kIsWeb ? 10.0 : 3.333,
    triangleSize: !kIsWeb ? 30.0 : 10.0,
  ));
  final List<String> _userMeetingIds = [];
  final newMarkerId = const MarkerId('NewMarker');

  // void _onStarted(_MarkerStarted event, Emitter<MarkerState> emit) async {
  //   emit(state.copyWith(status: MarkerStatus.loading));

  //   await _mapHelper.initializeVariables();
  //   await emit.onEach(_meetingRepository.meetings, onData: _onData);
  // }

  void _onData(List<Meeting> meetings) {
    final Set<Marker> markers = state.markers;

    final newMarkers = meetings.map((meeting) {
      Marker? marker = markers.cast<Marker?>().firstWhere(
          (marker) => marker?.markerId.value == meeting.id,
          orElse: () => null);
      if (marker != null) {
        return marker;
      }
      return _createMarker(meeting);
    }).toSet();

    add(_MarkerFetched(newMarkers));
  }

  String _iconColor(String? meetingId, String hostUid) {
    if (hostUid == FirebaseAuth.instance.currentUser?.uid) {
      // host일때
      return IconColors.host.name;
    } else if (_userMeetingIds.contains(meetingId)) {
      // 참여중인 모임일때
      return IconColors.join.name;
    }
    // 둘다 아닐때
    return IconColors.defalt.name;
  }

  Marker _createMarker(Meeting meeting) {
    final iconColor = _iconColor(meeting.id, meeting.hostUid);

    final loadingIcon = _mapHelper.loadingIcons[iconColor]!;

    final marker = Marker(
      markerId: MarkerId(meeting.id!),
      position: meeting.location,
      icon: loadingIcon,
    );

    return marker;
  }

  void _onUpdated(MarkerUpdated event, Emitter<MarkerState> emit) async {
    // emit(state.copyWith(status: MarkerStatus.loading));

    // final Set<Marker> meetingMarkers = state.markers;
    // final List<UserMeeting> userMeetings = event.userMeetings;

    // BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size(48, 48)), Assets.imageNuduwaLogo);

    // final updatedMarkers = meetingMarkers.map((marker) {
    //   if (userMeetings
    //       .map((userMeeting) => userMeeting.id)
    //       .contains(marker.markerId.value)) {
    //     final updatedMarker = marker.copyWith(
    //       iconParam: icon,
    //     );
    //     return updatedMarker;
    //   }
    //   return marker; // 수정할 필요가 없는 경우 그대로 반환
    // }).toSet();

    // add(_MarkerFetched(updatedMarkers));
  }

  void _onAddedCenter(MarkerAddedCenter event, Emitter<MarkerState> emit) {
    final center = event.center;
    final markers = state.markers;
    final newMarker = state.newMarker;
    late final Marker updatedNewMarker;

    if (newMarker != null) {
      updatedNewMarker = newMarker.copyWith(
        positionParam: center,
      );
      markers.remove(newMarker);
    } else {
      updatedNewMarker = Marker(
        markerId: newMarkerId,
        position: center,
      );
    }
    markers.add(updatedNewMarker);

    emit(state.copyWith(markers: markers, newMarker: updatedNewMarker));
  }

  void _onRemovedCenter(MarkerRemovedCenter event, Emitter<MarkerState> emit) {
    final markers = state.markers;
    final newMarker = state.newMarker;

    if (newMarker != null) {
      markers.remove(newMarker);
    }

    final emptyMarker = Marker(markerId: newMarkerId);

    emit(state.copyWith(markers: markers, newMarker: emptyMarker));
  }

  @override
  Future<void> close() {
    _meetingsSubscription.cancel();
    return super.close();
  }
}