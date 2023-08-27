import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_list/bloc/meeting_bloc.dart';

class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        if (state.meeting == null) {
          return const Center();
        }
        return SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              meetingListTile(state.meeting),
              if (FirebaseAuth.instance.currentUser?.uid == state.meeting?.hostUid)
              hostRibbon(),
            ],
          ),
        );
      },
    );
  }

  ListTile meetingListTile(Meeting? meeting) {
    String? time = meeting == null
        ? null
        : DateFormat("y년 M월 d일 a hh:mm").format(meeting.meetingTime);
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      onTap: onTap,
      leading: SizedBox(
        width: 50,
        height: 50,
        child: CircleAvatar(
                foregroundImage: meeting?.hostImageUrl != null
                    ? NetworkImage(meeting!.hostImageUrl!) as ImageProvider
                    : const AssetImage(Assets.imageNoImage),
                backgroundImage:
                    const AssetImage(Assets.imageLoading), // 로딩 중일 때 보여줄 배경색
              ),
      ),
      title: Text(
        meeting?.title ?? '',
        style: const TextStyle(
          fontSize: 28,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        '$time에 만나요 | ${meeting?.hostName ?? ''}',
        style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
      ),
    );
  }

  Stack hostRibbon() {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(1.0, -1.0),
          child: ClipPath(
            clipper: TrapezoidClipper(),
            child: Container(
              width: 70,
              height: 70,
              color: Colors.blue,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 9),
            child: Transform.rotate(
              angle: math.pi / 4, // 45도 회전
              child: const Text(
                'MINE',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2 + 5, 0);
    path.lineTo(size.width, size.height / 2 - 5);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
