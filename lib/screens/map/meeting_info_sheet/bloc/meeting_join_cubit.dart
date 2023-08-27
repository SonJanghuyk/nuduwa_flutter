import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';

part 'meeting_join_state.dart';

class MeetingJoinCubit extends Cubit<MeetingJoinState> {
  MeetingJoinCubit({
    required MeetingRepository meetingRepository,
  })  : _meetingRepository = meetingRepository,
        super(const MeetingJoinState.initial()){
          debugPrint('MeetingJoinCubit시작');
        }

  final MeetingRepository _meetingRepository;

  void joinMeeting(String meetingId, String hostUid) async {
    emit(state.copyWith(status: MeetingJoinStatus.loading));

    await _meetingRepository.join(meetingId, hostUid);
    emit(state.copyWith(status: MeetingJoinStatus.success));
  }

  @override
  Future<void> close() {
    debugPrint('MeetingJoinCubit끝');
    return super.close();
  }
}
