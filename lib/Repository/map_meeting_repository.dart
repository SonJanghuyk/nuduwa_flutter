import 'package:nuduwa_flutter/firebase/firebase_manager.dart';
import 'package:nuduwa_flutter/models/meeting.dart';

class MapMeetingRepository {

  Stream<List<Meeting>> get meetings {
    final ref = FirebaseManager.meetingList;
    final stream = ref.streamAllDocuments<Meeting>();

    return stream;
  }  
}
