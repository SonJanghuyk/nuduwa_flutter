part of 'meeting_info_bloc.dart';

sealed class MeetingInfoEvent extends Equatable {
  const MeetingInfoEvent();

  @override
  List<Object> get props => [];
}

final class _MeetingInfoStarted extends MeetingInfoEvent {}

final class MeetingInfoDragged extends MeetingInfoEvent {
  const MeetingInfoDragged(this.dragDetails);

  final DragUpdateDetails dragDetails;

  @override
  List<Object> get props => [dragDetails];
}

final class MeetingInfoDraggedEnd extends MeetingInfoEvent {}

final class MeetingInfoDoubleTapped extends MeetingInfoEvent {}

