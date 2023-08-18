part of 'create_meeting_cubit.dart';

class CreateMeetingState extends Equatable {
  const CreateMeetingState({
    this.title = const TitleInput.pure(),
    this.description = const DescriptionInput.pure(),
    this.place = const PlaceInput.pure(),
    this.maxMembers = const MaxMembersInput.pure(),
    this.category = const CategoryInput.pure(),
    this.location = const LatLng(0.0, 0.0),
    this.goeHash,
    this.meetingTime = const MeetingTimeInput.pure(),
    this.hostUid = '',
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final TitleInput title;
  final DescriptionInput description;
  final PlaceInput place;
  final MaxMembersInput maxMembers;
  final CategoryInput category;
  final LatLng location;
  final String? goeHash;
  final MeetingTimeInput meetingTime;
  final String hostUid;

  final FormzSubmissionStatus status;
  final bool isValid;

  final String? errorMessage;

  @override
  List<Object?> get props => [
        title,
        description,
        place,
        maxMembers,
        category,
        location,
        goeHash,
        meetingTime,
        hostUid,
        status,
        isValid,
        errorMessage,
      ];

  CreateMeetingState copyWith({
    TitleInput? title,
    DescriptionInput? description,
    PlaceInput? place,
    MaxMembersInput? maxMembers,
    CategoryInput? category,
    LatLng? location,
    String? goeHash,
    MeetingTimeInput? meetingTime,
    DateTime? publishedTime,
    String? hostUid,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return CreateMeetingState(
      title: title ?? this.title,
      description: description ?? this.description,
      place: place ?? this.place,
      maxMembers: maxMembers ?? this.maxMembers,
      category: category ?? this.category,
      location: location ?? this.location,
      goeHash: goeHash ?? this.goeHash,
      meetingTime: meetingTime ?? this.meetingTime,
      hostUid: hostUid ?? this.hostUid,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
