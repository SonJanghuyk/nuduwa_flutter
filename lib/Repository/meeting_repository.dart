import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/firebase/firebase_manager.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/member.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

class MeetingRepository {
  final geo = GeoFlutterFire();

  Stream<List<Meeting>> get meetings {
    final ref = FirebaseManager.meetingList;
    final stream = ref.streamAllDocuments<Meeting>();

    return stream;
  }

  /// Create Meeting Data
  Future<void> create({
    required String title,
    required String description,
    required String place,
    required int maxMembers,
    required String category,
    required LatLng location,
    required DateTime meetingTime,
  }) async {
    final meetingsRef = FirebaseManager.meetingList;    
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final geoPoint =
        geo.point(latitude: location.latitude, longitude: location.latitude);
        debugPrint('geo ${geoPoint.data}');
    final Map<String, dynamic> position = geoPoint.data;

    try {
      final newMeeting = Meeting(
        title: title,
        description: description,
        place: place,
        maxMembers: maxMembers,
        category: category,
        location: location,
        position: position,
        meetingTime: meetingTime,
        hostUid: uid!,
      );

      final newMeetingRef = await meetingsRef.add(newMeeting);
      final meetingId = newMeetingRef.id;
      final membersRef = FirebaseManager.memberList(meetingId);
      final userMeetingRef = FirebaseManager.userMeetingList(uid);

      final newMember = Member(uid: uid);
      final newUserMeeting = UserMeeting(meetingId: meetingId, hostUid: uid);

      await Future.wait([
         membersRef.add(newMember),
         userMeetingRef.add(newUserMeeting),
      ]);

      
    } catch (e) {
      debugPrint('createMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }
}