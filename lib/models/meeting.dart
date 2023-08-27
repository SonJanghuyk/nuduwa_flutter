import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/firebase/firebase_manager.dart';

class Meeting extends Equatable{
  final String? id;

  final String title;
  final String description;
  final String place;
  final int maxMembers;
  final MeetingCategory category;

  final LatLng location;
  final Map<String, dynamic>? position;

  final DateTime meetingTime;
  DateTime publishedTime;

  final String hostUid;
  String? hostName;
  String? hostImageUrl;

  final bool isEnd;

  Meeting({
    this.id,
    required this.title,
    required this.description,
    required this.place,
    required this.maxMembers,
    required this.category,
    required this.location,
    this.position,
    required this.meetingTime,
    DateTime? publishedTime,
    required this.hostUid,
    this.hostName,
    this.hostImageUrl,
    bool? isEnd,
  }) : publishedTime = publishedTime ??
            DateTime.now().toUtc().add(const Duration(hours: 9)),
        isEnd = isEnd ?? false;

  factory Meeting.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final categoryData = data?['category'] as String;
    final category = MeetingCategory.fromCategory(categoryData);
    final latitude = data?['latitude'] as double;
    final longitude = data?['longitude'] as double;
    final publishedTime = data?['publishedTime'] as Timestamp? ?? Timestamp.now();
    if (latitude == null) {
      return throw '에러! some meeting data is null';
    }

    return Meeting(
      id: snapshot.id,
      title: data?['title'],
      description: data?['description'],
      place: data?['place'],
      maxMembers: data?['maxMembers'],
      category: category,
      location: LatLng(latitude, longitude),
      position: data?['position'],
      meetingTime: data?['meetingTime'].toDate(),
      publishedTime: publishedTime.toDate(),
      hostUid: data?['hostUID'],
      isEnd: data?['isEnd'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "description": description,
      "place": place,
      "maxMembers": maxMembers,
      "category": category.category,
      "latitude": location.latitude,
      "longitude": location.longitude,
      if (position != null) "position": position,
      "meetingTime": meetingTime,
      "publishedTime": FieldValue.serverTimestamp(),
      "hostUID": hostUid,
      "isEnd" : isEnd,
    };
  }

  factory Meeting.clone(Meeting meeting) {
    return Meeting(
      id: meeting.id,
      title: meeting.title,
      description: meeting.description,
      place: meeting.place,
      maxMembers: meeting.maxMembers,
      category: meeting.category,
      location: meeting.location,
      position: meeting.position,
      meetingTime: meeting.meetingTime,
      publishedTime: meeting.publishedTime,
      hostUid: meeting.hostUid,
      hostName: meeting.hostName,
      hostImageUrl: meeting.hostImageUrl,
      isEnd: meeting.isEnd,
    );
  }

  factory Meeting.isEmpty({String? id}) {
    return Meeting(
      id: id ?? '',
      title: '',
      description: '',
      place: '',
      maxMembers: 0,
      category: MeetingCategory.all,
      location: const LatLng(0, 0),
      position: null,
      meetingTime: DateTime(0),
      publishedTime: null,
      hostUid: '',
      hostName: '',
      hostImageUrl: '',
      isEnd: null,
    );
  }

  @override
  List<Object?> get props => [id, title, description, place, maxMembers, category, location, position, meetingTime, publishedTime, hostUid, hostName, hostImageUrl, isEnd];
}

enum MeetingCategory {
  all('all', '전체'),
  hobby('hobby', '취미활동'),
  meal('meal', '식사'),
  drink('drink', '술자리'),
  exercise('exercise', '운동'),
  date('date', '소개팅'),
  talk('talk', '수다');

  final String category;
  final String displayName;
  const MeetingCategory(this.category, this.displayName);

  static MeetingCategory fromCategory(String categoryString) {
    for (var category in values) {
      if (category.category == categoryString) {
        return category;
      }
    }
    return MeetingCategory.all;
  }
}

class MeetingDataProvider{

  /// Create Meeting Data
  Future<DocumentReference<Meeting>> create({
    required String title,
    required String description,
    required String place,
    required int maxMembers,
    required MeetingCategory category,
    required LatLng location,
    required Map<String, dynamic> position,
    required DateTime meetingTime,
    required String hostUid,}) async {

    
    try {
      final ref = FirebaseManager.meetingList;

      final newMeeting = Meeting(
        title: title,
        description: description,
        place: place,
        maxMembers: maxMembers,
        category: category,
        location: location,
        position: position,
        meetingTime: meetingTime,
        hostUid: hostUid,
      );

      final newMeetingRef = await ref.add(newMeeting);
      // final meetingId = newMeetingRef.id;
      // await MemberRepository.create(memberUid: uid, meetingId: meetingId, hostUid: uid);
      return newMeetingRef;

    } catch (e) {
      debugPrint('createMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Read Meeting Data
  Future<Meeting?> read(String meetingId) async {
    final ref = FirebaseManager.meetingList.doc(meetingId);
    try{
      final data = ref.getDocument<Meeting?>();
      return data;

    }catch(e){
      debugPrint('readMeetingData에러: ${e.toString()}');
      rethrow;
    } 
  }  

  /// Update Meeting Data
  Future<void> update(
      {required String meetingId,
      String? title,
      String? description,
      String? place}) async {
    final ref = FirebaseManager.meetingList.doc(meetingId);
    try {
      await ref.update({
        if (title != null) "title": title,
        if (description != null) "description": description,
        if (place != null) "place": place,
      });

    } catch (e) {
      debugPrint('updateMeetingData에러: ${e.toString()}');
      rethrow;
    }
  }

  /// Listen Meetings Data
  Stream<Meeting?> stream({required String meetingId}) {
    final ref = FirebaseManager.meetingList.doc(meetingId);
    final stream = ref.streamDocument<Meeting>();

    return stream;
  }

  /// Listen Meetings Data
  Stream<List<Meeting>> streamAllDocuments() {
    final ref = FirebaseManager.meetingList;
    final stream = ref.streamAllDocuments<Meeting>();

    return stream;
  }

  // Future<Meeting> fetchHostNameAndImage(Meeting meeting) async {
  //   final (name, image) = await UserRepository.readOnlyNameAndImage(meeting.hostUid);
  //   final fetchMeeting = meeting;
  //   fetchMeeting.hostName = name;
  //   fetchMeeting.hostImageUrl = image;
  //   return fetchMeeting;
  // }

  

  // Meeting tempMeetingData() {
  //   return Meeting(
  //     title: '',
  //     description: '',
  //     place: '',
  //     maxMembers: 0,
  //     category: '',
  //     location: const LatLng(0, 0),
  //     meetingTime: DateTime(0),
  //     hostUid: '',
  //   );
  // }
}