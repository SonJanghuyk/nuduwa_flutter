import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('MeetingScreen'),
          TextButton(onPressed: () => GoRouter.of(context).go('/meeting/detail/imhere'), child: Text('DetailMeeting'))
        ],
      ),
    );
  }
}
