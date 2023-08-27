part of 'meeting_edit_cubit.dart';

final class MeetingEditState extends Equatable {
  const MeetingEditState({
    this.title = const TitleInput.pure(),
    this.description = const DescriptionInput.pure(),
    this.place = const PlaceInput.pure(),
    this.maxMembers = const MaxMembersInput.pure(),
    this.category = const CategoryInput.pure(),
    this.meetingTime = const MeetingTimeInput.pure(),
    this.formzStatus = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final TitleInput title;
  final DescriptionInput description;
  final PlaceInput place;
  final MaxMembersInput maxMembers;
  final CategoryInput category;
  final MeetingTimeInput meetingTime;

  final FormzSubmissionStatus formzStatus;
  final bool isValid;
  final String? errorMessage;

  MeetingEditState copyWith({
    TitleInput? title,
    DescriptionInput? description,
    PlaceInput? place,
    MaxMembersInput? maxMembers,
    CategoryInput? category,
    MeetingTimeInput? meetingTime,
    DateTime? publishedTime,
    FormzSubmissionStatus? formzStatus,
    bool? isValid,
    String? Function()? errorMessage,
  }) {
    return MeetingEditState(
      title: title ?? this.title,
      description: description ?? this.description,
      place: place ?? this.place,
      maxMembers: maxMembers ?? this.maxMembers,
      category: category ?? this.category,
      meetingTime: meetingTime ?? this.meetingTime,
      formzStatus: formzStatus ?? this.formzStatus,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        place,
        maxMembers,
        category,
        meetingTime,
        formzStatus,
        isValid,
        errorMessage,
      ];
}
