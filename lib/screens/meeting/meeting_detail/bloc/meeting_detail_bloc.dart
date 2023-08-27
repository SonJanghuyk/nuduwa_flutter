import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/models/member.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';

part 'meeting_detail_event.dart';
part 'meeting_detail_state.dart';

class MeetingDetailBloc extends Bloc<MeetingDetailEvent, MeetingDetailState> {
  MeetingDetailBloc({
    required MeetingRepository meetingRepository,
    required String meetingId,
  })  : _meetingRepository = meetingRepository,
        super(const MeetingDetailState()) {
    on<_MeetingDetailListenedMembers>(_listenedMembers);
    on<_MeetingDetailFetchedMembers>(_fetchedMembers);
    on<MeetingDetailWasEditing>(_wasEditing);
    on<MeetingDetailCanceledEditing>(_canceledEditing);
    on<MeetingDetailFinishedEditing>(_finishedEditing);

    _membersSubscription = _meetingRepository.members(meetingId).listen(
          (members) => add(_MeetingDetailListenedMembers(members)),
        );
  }

  final MeetingRepository _meetingRepository;
  late final StreamSubscription<List<Member>> _membersSubscription;

  void _listenedMembers(
      _MeetingDetailListenedMembers event, Emitter<MeetingDetailState> emit) {
    final preMembers = state.members;
    final newMembers = Map<String, Member>.fromIterable(
      event.members,
      key: (member) => member.id!,
      value: (member) {
        if (preMembers.keys.contains(member.id)) return preMembers[member.id]!;
        _fetchedNameAndImage(member);
        return member;
      },
    );
    add(_MeetingDetailFetchedMembers(newMembers));
    debugPrint('MeetingDetailBloc시작');
  }

  Future<void> _fetchedNameAndImage(Member member) async {
    final data = await _meetingRepository.getUserNameAndImage(member.uid);
    member.name = data.name;
    member.imageUrl = data.image;
    final members = state.members;
    members[member.id!] = member;
    add(_MeetingDetailFetchedMembers(members));
  }

  void _fetchedMembers(
      _MeetingDetailFetchedMembers event, Emitter<MeetingDetailState> emit) {
    emit(state.copyWith(members: event.members));
  }

  void _wasEditing(MeetingDetailWasEditing event, Emitter<MeetingDetailState> emit){
    emit(state.copyWith(status: MeetingDetailStatus.editing));

  }

  void _canceledEditing(MeetingDetailCanceledEditing event, Emitter<MeetingDetailState> emit){
    emit(state.copyWith(status: MeetingDetailStatus.notEditing));
  }

  void _finishedEditing(MeetingDetailFinishedEditing event, Emitter<MeetingDetailState> emit){
    emit(state.copyWith(status: MeetingDetailStatus.editLoading));
    emit(state.copyWith(status: MeetingDetailStatus.notEditing));
  }

  @override
  Future<void> close() {
    debugPrint('MeetingDetailBloc끝');
    _membersSubscription.cancel();
    return super.close();
  }
}
