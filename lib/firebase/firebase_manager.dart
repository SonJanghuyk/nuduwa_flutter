import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/user.dart';
import 'package:nuduwa_flutter/models/user_chatting.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';

class FirebaseManager {
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  // User Collection
  static CollectionReference<User> get userList =>
      db.collection('User').withConverter<User>(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, options) => user.toFirestore(),
          );
  static CollectionReference<UserMeeting> userMeetingList(String uid) => db
      .collection('User')
      .doc(uid)
      .collection('UserMeeting')
      .withConverter<UserMeeting>(
        fromFirestore: UserMeeting.fromFirestore,
        toFirestore: (UserMeeting userMeeting, options) =>
            userMeeting.toFirestore(),
      );

  static CollectionReference<UserChatting> userChattingList(String uid) => db
      .collection('User')
      .doc(uid)
      .collection('UserChatting')
      .withConverter<UserChatting>(
        fromFirestore: UserChatting.fromFirestore,
        toFirestore: (UserChatting userChatting, options) =>
            userChatting.toFirestore(),
      );

  // // Meeting Collection
  static CollectionReference get meetingList =>
      db.collection('Meeting').withConverter<Meeting>(
            fromFirestore: Meeting.fromFirestore,
            toFirestore: (Meeting meeting, options) => meeting.toFirestore(),
          );
  // static CollectionReference<Member> memberList(String meetingId) => /* ... */
  // static CollectionReference<Message> meetingMessageList(String meetingId) => /* ... */

  // // Chatting Collection
  // static CollectionReference<ChatRoom> get chattingList => /* ... */
  // static CollectionReference<Message> chattingMessageList(String chatttingId) => /* ... */
}

extension FirestoreQueryExtension on Query {
  /// Get All Items in Query
  Future<List<T>> getAllDocuments<T>() async {
    final snapshots = await get();
    final list = snapshots.docs
        .map((doc) => doc.data() as T)
        .where((data) => data != null)
        .toList();

    return list;
  }

  /// Get First Item in Query
  Future<T?> getDocument<T>() async {
    final snapshots = await get();
    final docs = snapshots.docs
        .map((doc) => doc.data() as T?)
        .where((data) => data != null);

    final data = docs.isEmpty ? null : docs.first;

    return data;
  }

  /// Listen First Items in Query
  Stream<T?> streamDocument<T>() {
    final stream = snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data())
        .where((data) => data != null)
        .first as T?);
    return stream;
  }

  /// Listen All Items in Query
  Stream<List<T>> streamAllDocuments<T>() {
    final stream = snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as T)
        .where((data) => data != null)
        .toList());
    return stream;
  }
}

extension FirestoreDocumentReferenceExtension on DocumentReference {
  /// Get Item in DocumentReference
  Future<T?> getDocument<T>() async {
    final snapshots = await get();
    final data = snapshots.data() as T?;
    return data;
  }

  /// Listen Item in DocumentReference
  Stream<T?> streamDocument<T>() {
    final stream = snapshots().map((snapshot) => snapshot.data() as T?);
    return stream;
  }
}
