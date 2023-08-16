import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuduwa_flutter/firebase/firebase_manager.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

class UserMeetingRepository {

  String get currentUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<List<UserMeeting>> get userMeetings {
    final ref = FirebaseManager.userMeetingList(currentUid);
    final stream = ref.streamAllDocuments<UserMeeting>();

    return stream;
  }  
}
