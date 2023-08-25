part of 'meeting_info_bloc.dart';

enum MeetingInfoStatus {
  initial,
  loading,
  loaded,
  error,
  close,
}

final class MeetingInfoState extends Equatable {
  const MeetingInfoState({
    required this.status,
    required this.height,
    this.isDraggedEnd = false,
    this.isUp = false,
    this.members = const [],
    this.errorMessage,
  });

  final MeetingInfoStatus status;
  final double height;
  final bool isDraggedEnd;
  final bool isUp;
  final List<Member> members;
  final String? errorMessage;

  const MeetingInfoState.initial({required double height})
      : this(
          status: MeetingInfoStatus.initial,
          height: height,
        );

  MeetingInfoState copyWith({
    MeetingInfoStatus? status,
    double? height,
    bool? isDraggedEnd,
    bool? isUp,
    List<Member>? members,
    String? errorMessage,
  }) {
    return MeetingInfoState(
      status: status ?? this.status,
      height: height ?? this.height,
      isDraggedEnd: isDraggedEnd ?? this.isDraggedEnd,
      isUp: isUp ?? this.isUp,
      members: members ?? this.members,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, height, isDraggedEnd, isUp, members, errorMessage];
}
