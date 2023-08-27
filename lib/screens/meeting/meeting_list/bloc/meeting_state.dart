part of 'meeting_bloc.dart';

enum MeetingStatus {
  initial,
  stream,
  pause,
  error,
}

final class MeetingState{// extends Equatable {
  const MeetingState({
    this.status = MeetingStatus.initial,
    this.meeting,
    this.errorMessage,
  });

  final MeetingStatus status;
  final Meeting? meeting;
  final String? errorMessage;

  /*
   속성에 null 값도 넣을 수 있게 Funtion()으로 만듬
   ex) state.copyWith(errorMessage: null)이면 state에 있던 errorMessage 그대로 복사하고
       state.copyWith(errorMessage: () => null)이면 errorMessage = null이 됨
  */
  MeetingState copyWith({
    MeetingStatus? status,
    Meeting? meeting,
    String? Function()? errorMessage,
  }) {
    return MeetingState(
      status: status ?? this.status,
      meeting: meeting ?? this.meeting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  // @override
  // List<Object?> get props => [status, meeting, errorMessage];
}
