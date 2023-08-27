import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/firebase/firebase_manager.dart';

class UserMeeting {
  final String? id;
  final String meetingId;
  final String hostUid;
  final bool isEnd;
  final List<String>? nonReviewMembers;

  UserMeeting({
    this.id,
    required this.meetingId,
    required this.hostUid,
    bool? isEnd,
    this.nonReviewMembers,
  }): isEnd = isEnd ?? false;

  factory UserMeeting.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    final meetingId = data?['meetingId'] as String?;
    final hostUid = data?['hostUid'] as String?;
    final isEnd = data?['isEnd'] as bool?;
    if (meetingId == null || hostUid == null || isEnd == null) {
      return throw '에러! something is null';
    }

    return UserMeeting(
      id: snapshot.id,
      meetingId: meetingId,
      hostUid: hostUid,
      isEnd: isEnd,
      nonReviewMembers: data?['nonReviewMembers'] as List<String>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "meetingId": meetingId,
      "hostUid": hostUid,
      "isEnd": isEnd,
    };
  }
}

class UserMeetingDataProvider {

  /// Create UserMeeting Data
  Future<DocumentReference<UserMeeting>?> create(
      {required String uid, required String meetingId, required String hostUid}) async {

    final userMeeting =
        UserMeeting(meetingId: meetingId, hostUid: hostUid, isEnd: false);
    final ref = FirebaseManager.userMeetingList(uid).doc();

    try {
      await ref.set(userMeeting);
      return ref;
    } catch (e) {
      debugPrint('createUserMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Read UserMeeting Data
  Future<UserMeeting?> read({required String uid, required String meetingId}) async {
    final ref =
        FirebaseManager.userMeetingList(uid).where('meetingId', isEqualTo: meetingId);

    try {
      final data = await ref.getDocument<UserMeeting?>();
      return data;
    } catch (e) {
      debugPrint('readUserMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Delete UserMeeting Data
  Future<void> delete(
      { required String uid, required String meetingId}) async {
    final query =
        FirebaseManager.userMeetingList(uid).where('meetingId', isEqualTo: meetingId);

    try {
      final snapshot = await query.get();
      final ref = snapshot.docs.first.reference;
      await ref.delete();
    } catch (e) {
      debugPrint('deleteUserMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Listen UserMeetings Data
  Stream<List<UserMeeting>> stream(String uid) {
    final ref = FirebaseManager.userMeetingList(uid);
    final stream = ref.streamAllDocuments<UserMeeting>();

    return stream;
  }
}
