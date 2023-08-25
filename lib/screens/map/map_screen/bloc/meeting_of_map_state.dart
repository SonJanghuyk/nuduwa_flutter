part of 'meeting_of_map_bloc.dart';

enum MeetingOfMapStatus {
  initial,
  stream,
  pause,
  error,
}

final class MeetingOfMapState{ // extends Equatable {
  const MeetingOfMapState({
    this.status = MeetingOfMapStatus.initial,
    this.meetings = const {},
    this.errorMessage,
  });

  final MeetingOfMapStatus status;
  final Map<String, Meeting> meetings;
  final String? errorMessage;

   /*
   속성에 null 값도 넣을 수 있게 Funtion()으로 만듬
   ex) state.copyWith(errorMessage: null)이면 state에 있던 errorMessage 그대로 복사하고
       state.copyWith(errorMessage: () => null)이면 errorMessage = null이 됨
  */  
  MeetingOfMapState copyWith({
    MeetingOfMapStatus? status,
    Map<String, Meeting>?  meetings,
    String Function()? errorMessage,
  }) {
    return MeetingOfMapState(
      status: status ?? this.status,
      meetings: meetings ?? this.meetings,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
  
  // @override
  // List<Object?> get props => [status, meetings, errorMessage];
}
