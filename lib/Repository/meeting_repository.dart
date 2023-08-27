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
  final _meetingDataProvider = MeetingDataProvider();
  final _userDataProvider = UserDataProvider();
  final _memberDataProvider = MemberDataProvider();
  final _userMeetingDataProvider = UserMeetingDataProvider();

  final geo = GeoFlutterFire();

  String? get currentUid => auth.FirebaseAuth.instance.currentUser?.uid;

  Stream<List<Meeting>> get meetings {
    final stream = _meetingDataProvider.streamAllDocuments();

    return stream;
  }

  Stream<List<Member>> members(String meetingId) {
    final ref = FirebaseManager.memberList(meetingId);
    final stream = ref.streamAllDocuments<Member>();

    return stream;
  }

  Stream<Meeting?> meeting(String meetingId) {
    final stream = _meetingDataProvider.stream(meetingId: meetingId);

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
    required MeetingCategory category,
    required LatLng location,
    required DateTime meetingTime,
  }) async {
    try {
      if (currentUid == null) return;
      final geoPoint =
          geo.point(latitude: location.latitude, longitude: location.latitude);
      final Map<String, dynamic> position = geoPoint.data;

      final ref = await _meetingDataProvider.create(
        title: title,
        description: description,
        place: place,
        maxMembers: maxMembers,
        category: category,
        location: location,
        position: position,
        meetingTime: meetingTime,
        hostUid: currentUid!,
      );
      final meetingId = ref.id;

      await Future.wait([
        _memberDataProvider.create(
            memberUid: currentUid!, meetingId: meetingId),
        _userMeetingDataProvider.create(
            uid: currentUid!, meetingId: meetingId, hostUid: currentUid!),
      ]);
    } catch (e) {
      debugPrint('createMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }

  Future<Meeting> fetchHostNameAndImage(Meeting meeting) async {
    final data = await _userDataProvider.readOnlyNameAndImage(meeting.hostUid);
    meeting.hostName = data.name;
    meeting.hostImageUrl = data.image;
    return meeting;
  }

  Future<({String? name, String? image})> getUserNameAndImage(
      String hostUid) async {
    final data = await _userDataProvider.readOnlyNameAndImage(hostUid);
    return data;
  }

  Future<void> join(String meetingId, String hostUid) async {
    if (currentUid == null) return;
    await Future.wait([
      _memberDataProvider.create(memberUid: currentUid!, meetingId: meetingId),
      _userMeetingDataProvider.create(uid: currentUid!, meetingId: meetingId, hostUid: hostUid),
    ]);
  }
}
