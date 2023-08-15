import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/Repository/map_meeting_repository.dart';
import 'package:nuduwa_flutter/models/meeting.dart';

part 'map_meeting_event.dart';
part 'map_meeting_state.dart';

class MapMeetingBloc extends Bloc<MapMeetingEvent, MapMeetingState> {
  MapMeetingBloc({required MapMeetingRepository mapMeetingRepository})
      : _mapMeetingRepository = mapMeetingRepository,
        super(const MapMeetingState.initial()) {
    on<_MapMeetingFetched>(_onMeetingFetched);
    on<MapMeetingCreated>((event, emit) {});
    on<MapMeetingJoined>((event, emit) {});
    on<MapMeetingLeft>((event, emit) {});

    _meetingsSubscription = _mapMeetingRepository.meetings
        .listen((meetings) => add(_MapMeetingFetched(meetings)));
  }

  final MapMeetingRepository _mapMeetingRepository;
  late final StreamSubscription<List<Meeting>> _meetingsSubscription;

  void _onMeetingFetched(
      _MapMeetingFetched event, Emitter<MapMeetingState> emit) {
    final Set<Marker> meetingMarkers = {};

    emit(state.copyWith(status: MapMeetingStatus.loading));
    for (final meeting in event.meetings) {
      final marker =
          Marker(markerId: MarkerId(meeting.id!), position: meeting.location);
      meetingMarkers.add(marker);
    }
    emit(state.copyWith(
        status: MapMeetingStatus.loaded, meetingMarkers: meetingMarkers));
  }

  @override
  Future<void> close() {
    _meetingsSubscription.cancel();
    return super.close();
  }
}
