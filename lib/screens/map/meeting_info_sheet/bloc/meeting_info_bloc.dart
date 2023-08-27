import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nuduwa_flutter/models/member.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';

part 'meeting_info_event.dart';
part 'meeting_info_state.dart';

class MeetingInfoBloc extends Bloc<MeetingInfoEvent, MeetingInfoState> {
  MeetingInfoBloc({
    required MeetingRepository meetingRepository,
    required String meetingId,
    required double firstHeight,
    required double endHeight,
  })  : _meetingRepository = meetingRepository,
        _meetingId = meetingId,
        _firstHeight = firstHeight,
        _endHeight = endHeight,
        super(MeetingInfoState.initial(height: firstHeight)) {
    on<_MeetingInfoStarted>(_onStarted);
    on<MeetingInfoDragged>(_onDragged);
    on<MeetingInfoDraggedEnd>(_onDraggedEnd);
    on<MeetingInfoDoubleTapped>(_onDoubleTapped);

    add(_MeetingInfoStarted());

    debugPrint('MeetingInfoBloc시작');
  }

  final MeetingRepository _meetingRepository;
  final String _meetingId;
  final double _firstHeight;
  final double _endHeight;
  DateTime? _startDragged;

  void _onStarted(
      _MeetingInfoStarted event, Emitter<MeetingInfoState> emit) async {
    emit(state.copyWith(status: MeetingInfoStatus.loading));

    await emit.forEach(_meetingRepository.members(_meetingId),
        onData: (List<Member> members) =>
            state.copyWith(status: MeetingInfoStatus.loaded, members: members),
        onError: (error, stackTrace) {
          debugPrint('MeetingInfoBloc 에러: ${error.toString()}');
          return state.copyWith(
              status: MeetingInfoStatus.error, errorMessage: error.toString());
        });
  }

  void _onDragged(MeetingInfoDragged event, Emitter<MeetingInfoState> emit) {
    _startDragged ??= DateTime.now();
    final newHeight = state.height - event.dragDetails.delta.dy;
    emit(state.copyWith(height: newHeight, isDraggedEnd: false));
  }

  /* 
    드래그를 빨리 했을 때는 드래그를 조금만해도 sheet 크기가 변하고
    느리게 했을 때는 드래그를 많이 해야 sheet 크기가 변함
  */
  void _onDraggedEnd(
      MeetingInfoDraggedEnd event, Emitter<MeetingInfoState> emit) {
    final nowHeight = state.height;
    final timeDifference = DateTime.now().difference(_startDragged!);
    final isFast = timeDifference.inMilliseconds < 200 ? true : false;

    debugPrint('nowHeight: $nowHeight');
    debugPrint('isFastHeight: $isFast');
    debugPrint('endHeight: $_endHeight');

    if (isFast) {
      if (nowHeight < _firstHeight - 20) {
        emit(state.copyWith(status: MeetingInfoStatus.close));

      } else if (nowHeight < _firstHeight + 20) {
        _down(emit);

      } else if (nowHeight > _firstHeight + 20 &&
          nowHeight < _endHeight - _firstHeight) {
        _up(emit);

      } else if (nowHeight > (_endHeight + _firstHeight)/2 &&
          nowHeight < _endHeight - 20) {
        _down(emit);

      } else {
        _up(emit);
      }
    } else {
      if (nowHeight < _firstHeight - 100) {
        emit(state.copyWith(status: MeetingInfoStatus.close));

      } else if (nowHeight < (_endHeight + _firstHeight)/2) {
        _down(emit);

      } else {
        _up(emit);
      }
    }
      _startDragged = null;
  }
  
  void _down(Emitter<MeetingInfoState> emit) {
    emit(state.copyWith(height: _firstHeight, isDraggedEnd: true, isUp: false));
  }

  void _up(Emitter<MeetingInfoState> emit) {
    emit(state.copyWith(height: _endHeight, isDraggedEnd: true, isUp:  true));
  }

  void _onDoubleTapped(
      MeetingInfoDoubleTapped event, Emitter<MeetingInfoState> emit) {
    emit(state.copyWith(height: 600, isDraggedEnd: true));
  }

  @override
  Future<void> close() {
    debugPrint('MeetingInfoBloc끝');
    return super.close();
  }
}
