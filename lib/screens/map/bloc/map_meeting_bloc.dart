import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/repository/map_meeting_repository.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

part 'map_meeting_event.dart';
part 'map_meeting_state.dart';

class MapMeetingBloc extends Bloc<MapMeetingEvent, MapMeetingState> {
  MapMeetingBloc({required MapMeetingRepository mapMeetingRepository})
      : _mapMeetingRepository = mapMeetingRepository,
        super(const MapMeetingState.initial()) {
    on<_MapMeetingStarted>(_onMeetingStarted);
    on<_MapMeetingFetched>((event, emit) => emit(state.copyWith(
        status: MapMeetingStatus.loaded,
        meetingMarkers: event.meetingMarkers)));
    on<MapMeetingUpdated>(_onMeetingUpdated);

    add(_MapMeetingStarted());
  }

  final MapMeetingRepository _mapMeetingRepository;
  late final StreamSubscription<List<Meeting>> _meetingsSubscription;

  void _onMeetingStarted(
      _MapMeetingStarted event, Emitter<MapMeetingState> emit) async {
    emit(state.copyWith(status: MapMeetingStatus.loading));

    await emit.onEach(_mapMeetingRepository.meetings, onData: _onData);
  }

  void _onData(List<Meeting> meetings) {
    final Set<Marker> meetingMarkers = {};
    for (final meeting in meetings) {
      final marker =
          Marker(markerId: MarkerId(meeting.id!), position: meeting.location);
      meetingMarkers.add(marker);
    }
    add(_MapMeetingFetched(meetingMarkers));
  }

  void _onMeetingUpdated(
      MapMeetingUpdated event, Emitter<MapMeetingState> emit) async {
    emit(state.copyWith(status: MapMeetingStatus.loading));

    final Set<Marker> meetingMarkers = state.meetingMarkers;
    final List<UserMeeting> userMeetings = event.userMeetings;

    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)), Assets.imageNuduwaLogo);

    final updatedMarkers = meetingMarkers.map((marker) {
      if (userMeetings
          .map((userMeeting) => userMeeting.id)
          .contains(marker.markerId.value)) {
        final updatedMarker = marker.copyWith(
          iconParam: icon,
        );
        return updatedMarker;
      }
      return marker; // 수정할 필요가 없는 경우 그대로 반환
    }).toSet();

    add(_MapMeetingFetched(updatedMarkers));
  }

  @override
  Future<void> close() {
    _meetingsSubscription.cancel();
    return super.close();
  }
}
