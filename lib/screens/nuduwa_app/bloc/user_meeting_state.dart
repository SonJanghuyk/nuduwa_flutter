part of 'user_meeting_bloc.dart';

enum UserMeetingStatus {
  initial,
  loading,
  loaded,
  pause,
  error,
}

final class UserMeetingState extends Equatable {
  const UserMeetingState({
    required this.status,
    this.userMeetings = const [],
    this.errorMessage,
  });

  final UserMeetingStatus status;
  final List<UserMeeting> userMeetings;
  final String? errorMessage;

  const UserMeetingState.initial() : this(status: UserMeetingStatus.initial);

  UserMeetingState copyWith({
    UserMeetingStatus? status,
    List<UserMeeting>? userMeetings,
    String? errorMessage,
  }) {
    return UserMeetingState(
      status: status ?? this.status,
      userMeetings: userMeetings ?? this.userMeetings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, userMeetings, errorMessage];
}

