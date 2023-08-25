part of 'meeting_join_cubit.dart';

enum MeetingJoinStatus {
  initial,
  loading,
  success,
  failure,
  error,
}

final class MeetingJoinState extends Equatable {
  const MeetingJoinState({required this.status});

  final MeetingJoinStatus status;

  const MeetingJoinState.initial() : this(status: MeetingJoinStatus.initial);

  MeetingJoinState copyWith({
    MeetingJoinStatus? status,
  }) {
    return MeetingJoinState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}