import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/route/app_route.dart';

class MeetingDetailScreen extends StatelessWidget {
  const MeetingDetailScreen({
    required this.meetingId,
    super.key,
  });

  final String meetingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MeetingDetailScreen meetingId: $meetingId'),
            TextButton(
                onPressed: () => context.pushNamed(RouteNames.meetingChatroom, pathParameters: {'meetingId': meetingId}),
                child: const Text('ChatMeeting'))
          ],
        ),
      ),
    );
  }
}
