import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  // User Collection
  // static CollectionReference<User> get userList => /* ... */
  // static CollectionReference<UserMeeting> userMeetingList(String uid) => /* ... */
  // static CollectionReference<UserChatting> userChattingList(String uid) => /* ... */

  // // Meeting Collection
  // static CollectionReference<Meeting> get meetingList => /* ... */
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
