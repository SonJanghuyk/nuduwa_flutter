import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/firebase/firebase_manager.dart';

class Member {
  final String? id;
  final String uid;
  String? name;
  String? imageUrl;
  final DateTime? joinTime;

  Member({
    this.id,
    required this.uid,
    this.name,
    this.imageUrl,
    this.joinTime,
  });

  factory Member.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    final joinTime = data?['joinTime'] as Timestamp?;
    if (joinTime == null) {
      return throw '에러! joinTime is null';
    }
    return Member(
      id: snapshot.id,
      uid: data?['uid'] as String,
      name: data?['name'] as String?,
      imageUrl: data?['image'] as String?,
      joinTime: joinTime.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      if (name != null) "name": name,
      if (imageUrl != null) "image": imageUrl,
      "joinTime": FieldValue.serverTimestamp(),
    };
  }

  factory Member.clone(Member member) {
    return Member(
      id: member.id,
      uid: member.uid,
      name: member.name,
      imageUrl: member.imageUrl,
      joinTime: member.joinTime,
    );
  }
}

class MemberDataProvider {
  /// Create Member Data
  Future<DocumentReference<Member>?> create({
    required String memberUid,
    required String meetingId,
  }) async {
    try {
      final member = Member(uid: memberUid);
      final ref = FirebaseManager.memberList(meetingId).doc();
      await ref.set(member);
      return ref;
    } catch (e) {
      debugPrint('createMemberData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Read Member Data
  static Future<Member?> read(String meetingId, String memberUid) async {
    final query = FirebaseManager.memberList(meetingId)
        .where('uid', isEqualTo: memberUid);

    try {
      final data = query.getDocument<Member?>();
      return data;
    } catch (e) {
      debugPrint('readMemberData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Delete Member Data
  static Future<void> delete(
      {required String meetingId, required String memberUid}) async {
    try {
      final query =
          FirebaseManager.memberList(meetingId).where('uid', isEqualTo: memberUid);
      final snapshot = await query.get();
      final ref = snapshot.docs.first.reference;
      await ref.delete();
    } catch (e) {
      debugPrint('deleteMemberData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Listen Members Data
  static Stream<List<Member>> listenAllDocuments({required String meetingId}) {
    final ref = FirebaseManager.memberList(meetingId);
    final stream = ref.streamAllDocuments<Member>();

    return stream;
  }
}
