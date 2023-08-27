part of 'meeting_detail_bloc.dart';

sealed class MeetingDetailEvent extends Equatable {
  const MeetingDetailEvent();

  @override
  List<Object> get props => [];
}

final class _MeetingDetailListenedMembers extends MeetingDetailEvent{
  const _MeetingDetailListenedMembers(this.members);

  final List<Member> members;

  @override
  List<Object> get props => [members];
}

final class _MeetingDetailFetchedMembers extends MeetingDetailEvent{
  const _MeetingDetailFetchedMembers(this.members);

  final Map<String, Member> members;

  @override
  List<Object> get props => [members];
}

final class MeetingDetailWasEditing extends MeetingDetailEvent{ }

final class MeetingDetailCanceledEditing extends MeetingDetailEvent{ }

final class MeetingDetailFinishedEditing extends MeetingDetailEvent{ }
