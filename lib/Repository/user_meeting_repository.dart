import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

class UserMeetingRepository {
  final _userMeetingDataProvider = UserMeetingDataProvider();

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  Stream<List<UserMeeting>> get userMeetings {
    if (currentUid==null) return const Stream.empty();
    final stream = _userMeetingDataProvider.stream(currentUid!);

    return stream;
  }
}
