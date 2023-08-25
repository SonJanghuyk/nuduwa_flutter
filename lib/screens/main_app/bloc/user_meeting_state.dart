part of 'user_meeting_bloc.dart';

enum UserMeetingStatus {
  initial,
  stream,
  pause,
  error,
}

final class UserMeetingState extends Equatable {
  const UserMeetingState({
    this.status = UserMeetingStatus.initial,
    this.userMeetings = const [],
    this.errorMessage,
  });

  final UserMeetingStatus status;
  final List<UserMeeting> userMeetings;
  final String? errorMessage;

  /*
   속성에 null 값도 넣을 수 있게 Funtion()으로 만듬
   ex) state.copyWith(errorMessage: null)이면 state에 있던 errorMessage 그대로 복사하고
       state.copyWith(errorMessage: () => null)이면 errorMessage = null이 됨
  */
  UserMeetingState copyWith({
    UserMeetingStatus? status,
    List<UserMeeting>? userMeetings,
    String? Function()? errorMessage,
  }) {
    return UserMeetingState(
      status: status ?? this.status,
      userMeetings: userMeetings ?? this.userMeetings,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, userMeetings, errorMessage];
}

