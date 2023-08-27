import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

part 'meeting_of_map_event.dart';
part 'meeting_of_map_state.dart';

class MeetingOfMapBloc extends Bloc<MeetingOfMapEvent, MeetingOfMapState> {
  MeetingOfMapBloc({required MeetingRepository meetingRepository})
      : _meetingRepository = meetingRepository,
        super(const MeetingOfMapState()) {
    on<_MeetingOfMapListened>(_onListened);
    on<MeetingOfMapFetched>(_onFetched);
    on<_MeetingOfMapErrored>(_onErrored);
    on<MeetingOfMapPaused>(_onPaused);
    on<MeetingOfMapResumed>(_onResumed);
    on<MeetingOfMapUpdated>(_onUpdated);

    _meetingsSubscription = _meetingRepository.meetings.listen(
      (meetings) => add(_MeetingOfMapListened(meetings)),
      onError: (handleError) => add(_MeetingOfMapErrored(handleError)),
    );

    debugPrint('MeetingOfMapBloc시작');
  }

  final MeetingRepository _meetingRepository;
  late final StreamSubscription<List<Meeting>> _meetingsSubscription;

  void _onListened(_MeetingOfMapListened event, Emitter<MeetingOfMapState> emit) {
    emit(state.copyWith(status: MeetingOfMapStatus.stream));

    final preMeetings = state.meetings;

    // 이전에 불러온 Meeting 데이터 있으면 그대로 쓰고 없으면 새로운 데이터 넣기
    final newMeetings = {
      for (final meeting in event.meetings)
        meeting.id!: preMeetings[meeting.id!] ?? meeting
    };

    add(MeetingOfMapFetched(newMeetings));

    // 새로운 데이터는 HostName이 없으므로 새로 불러와서 적용하기
    for (final newMeeting in newMeetings.values) {
      if (newMeeting.hostName != null) continue;
      _meetingRepository.fetchHostNameAndImage(newMeeting)
      .then((meeting) {
        final meetings = state.meetings;
        meetings[meeting.id!] = meeting;
        add(MeetingOfMapFetched(meetings));
      });

    }
  }

  void _onFetched(MeetingOfMapFetched event, Emitter<MeetingOfMapState> emit) {
    emit(state.copyWith(meetings: event.meetings));
  }

  void _onErrored(_MeetingOfMapErrored event, Emitter<MeetingOfMapState> emit) {
    final errorMessage = event.toString();
    debugPrint('MapMeetingBlocListen에러!!: $errorMessage');
    emit(state.copyWith(
        status: MeetingOfMapStatus.error, errorMessage: () => errorMessage));
  }

  void _onPaused(MeetingOfMapPaused event, Emitter<MeetingOfMapState> emit) {
    _meetingsSubscription.pause();
    emit(state.copyWith(
      status: MeetingOfMapStatus.pause,
    ));
  }

  void _onResumed(MeetingOfMapResumed event, Emitter<MeetingOfMapState> emit) {
    _meetingsSubscription.resume();
  }

  void _onUpdated(MeetingOfMapUpdated event, Emitter<MeetingOfMapState> emit) async {
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

  @override
  Future<void> close() {
    debugPrint('MeetingOfMapBloc끝');
    _meetingsSubscription.cancel();
    return super.close();
  }
}
