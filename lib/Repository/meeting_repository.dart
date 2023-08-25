import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/firebase/firebase_manager.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/member.dart';
import 'package:nuduwa_flutter/models/user.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

class MeetingRepository {
  final geo = GeoFlutterFire();

  Stream<List<Meeting>> get meetings {
    final ref = FirebaseManager.meetingList;
    final stream = ref.streamAllDocuments<Meeting>();

    return stream;
  }

  Stream<List<Member>> members(String meetingId) {
    final ref = FirebaseManager.memberList(meetingId);
    final stream = ref.streamAllDocuments<Member>();

    return stream;
  }

  // Stream<int> membersCount(String meetingId) {
  //   final ref = FirebaseManager.memberList(meetingId);
  //   final stream = ref.snapshots()

  //   return stream;
  // }

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
    final uid = auth.FirebaseAuth.instance.currentUser?.uid;
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

  Future<Meeting> fetchHostNameAndImage(Meeting meeting) async {
    final user = await FirebaseManager.userList.doc(meeting.hostUid).getDocument<User?>();
    if (user == null) return meeting; // 계정 삭제 등 데이터 없을때
    final hostName = user.name;
    final hostImage = user.imageUrl;
    meeting.hostName = hostName;
    meeting.hostImageUrl = hostImage;
    return meeting;
  }

  Future<void> join(String meetingId) async {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final member = Member(uid: uid);

    final ref = FirebaseManager.memberList(meetingId);
    await ref.add(member);
  }

}