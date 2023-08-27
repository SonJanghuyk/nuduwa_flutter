part of 'meeting_detail_bloc.dart';

enum MeetingDetailStatus { notEditing, editing, editLoading }

final class MeetingDetailState {// extends Equatable {
  const MeetingDetailState({
    this.status = MeetingDetailStatus.notEditing,
    this.members = const {},
    this.errorMessage,
  });

  final MeetingDetailStatus status;
  final Map<String, Member> members;
  final String? errorMessage;

  MeetingDetailState copyWith({
    MeetingDetailStatus? status,
    Map<String, Member>? members,
    String? Function()? errorMessage,
  }) {
    return MeetingDetailState(
        status: status ?? this.status,
        members: members ?? this.members,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }

  // @override
  // List<Object?> get props => [status, members, errorMessage];
}
