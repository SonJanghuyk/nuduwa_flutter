import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MeetingDetailScreen extends StatelessWidget {
  const MeetingDetailScreen({
    required this.meetingId,
    super.key,
  });

  final String meetingId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('MeetingDetailScreen meetingId: $meetingId'),
          TextButton(
              onPressed: () => GoRouter.of(context).go('/meeting/chatroom'),
              child: Text('ChatMeeting')),
          Expanded(
            child: GoogleMap(
              onMapCreated: (_) {},
              initialCameraPosition: CameraPosition(
                // 초기 지도 위치
                target: const LatLng(45.521563, -122.677433),
                zoom: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
