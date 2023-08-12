import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/components/widgets/nuduwa_appbar.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';
import 'package:nuduwa_flutter/route/app_route.dart';
import 'package:nuduwa_flutter/app/meeting/meeting_card.dart';

class MeetingList extends StatelessWidget {
  MeetingList({super.key});

  final userMeetings = [
    UserMeeting(meetingId: '1', hostUid: '1', isEnd: false),
    UserMeeting(meetingId: '2', hostUid: '2', isEnd: false),
    UserMeeting(meetingId: '3', hostUid: '3', isEnd: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NuduwaAppBar(),
      body: ListView.separated(
        itemCount: userMeetings.length,
        itemBuilder: (context, index) {
          final meetingId = userMeetings[index].meetingId;
          final hostUid = userMeetings[index].hostUid;
          return MeetingCard(
            meetingId: meetingId,
            onTap: () => context.pushNamed(RouteNames.meetingDetail, pathParameters: {'meetingId': meetingId}),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(height: 0, child: Divider()),
      ),
    );
  }
}