import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/models/member.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/bloc/meeting_of_map_bloc.dart';
import 'package:nuduwa_flutter/screens/map/meeting_info_sheet/bloc/meeting_info_bloc.dart';
import 'package:nuduwa_flutter/screens/map/meeting_info_sheet/bloc/meeting_join_cubit.dart';

void meetingInfoSheet(BuildContext blocContext, String meetingId) {
  showModalBottomSheet(
    context: blocContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15.0),
      ),
    ),
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MeetingInfoBloc(
            meetingRepository: blocContext.read<MeetingRepository>(),
            meetingId: meetingId,
            firstHeight: 220,
            endHeight: 600,
          ),
        ),
        BlocProvider.value(value: blocContext.read<MeetingOfMapBloc>()),
      ],
      child: BlocListener<MeetingInfoBloc, MeetingInfoState>(
        listener: (context, state) {
          if (state.status == MeetingInfoStatus.close) {
            // context.pop();
          }
        },
        child: MeetingInfoScreen(
          meetingId: meetingId,
        ),
      ),
    ),
  );
}

class MeetingInfoScreen extends StatelessWidget {
  const MeetingInfoScreen({
    required this.meetingId,
    super.key,
  });

  final String meetingId;

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String formattedTime = DateFormat("a h:mm").format(dateTime);

    if (inputDate == today) {
      return '오늘 $formattedTime';
    } else if (inputDate == tomorrow) {
      return '내일 $formattedTime';
    } else {
      return DateFormat("M월 d일 ").format(dateTime) + formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (dragDetails) =>
          context.read<MeetingInfoBloc>().add(MeetingInfoDragged(dragDetails)),
      onVerticalDragEnd: (details) =>
          context.read<MeetingInfoBloc>().add(MeetingInfoDraggedEnd()),
      onDoubleTap: () =>
          context.read<MeetingInfoBloc>().add(MeetingInfoDoubleTapped()),
      child: BlocSelector<MeetingInfoBloc, MeetingInfoState,
          ({double height, bool isDraggedEnd, bool isUp})>(
        selector: (state) => (
          height: state.height,
          isDraggedEnd: state.isDraggedEnd,
          isUp: state.isUp
        ),
        builder: (context, select) {
          final height = select.height;
          final isDraggedEnd = select.isDraggedEnd;
          final isUp = select.isUp;
          return AnimatedContainer(
            height: height,
            // width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            duration: isDraggedEnd
                ? const Duration(milliseconds: 200)
                : const Duration(milliseconds: 0),
            color: Colors.transparent,
            child: BlocSelector<MeetingOfMapBloc, MeetingOfMapState, Meeting?>(
              selector: (state) => state.meetings[meetingId],
              builder: (context, meeting) {
                if (meeting == null) context.pop();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // HostImage
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircleAvatar(
                            radius: 20,
                            foregroundImage:
                                Image.network(meeting!.hostImageUrl!).image,
                            backgroundImage: Image.asset(Assets.imageLoading)
                                .image, // 로딩 중일 때 보여줄 이미지
                          ),
                        ),
                        const SizedBox(width: 30),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HostName
                            SizedBox(
                              // width: MediaQuery.of(context).size.width - 170,
                              height: 40,
                              child: meeting.hostName != null
                                  ? Text(
                                      meeting.hostName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Row(
                                      children: [
                                        SizedBox(width: 10),
                                        SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator()),
                                      ],
                                    ),
                            ),

                            // MeetingTime
                            Text(
                              '${formatDateTime(meeting.meetingTime)}에 만나요!',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // MeetingTitle
                    Center(
                      child: Text(
                        meeting.title,
                        style: const TextStyle(
                          fontSize: 35,
                        ),
                      ),
                    ),

                    if (height > 400)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: RowMeetingInfo(
                                    text: meeting.place,
                                    icon: Icons.location_on_outlined),
                              ),
                              Expanded(
                                child: RowMeetingInfo(
                                    text: meeting.description,
                                    icon: Icons.edit_outlined),
                              ),
                              Expanded(
                                child: RowMeetingInfo(
                                    text:
                                        '${formatDateTime(meeting.meetingTime)}에 만날꺼에요!',
                                    icon: Icons.calendar_month),
                              ),
                              BlocBuilder<MeetingInfoBloc, MeetingInfoState>(
                                builder: (context, state) {
                                  late final Widget membersCount;
                                  switch (state.status) {
                                    case MeetingInfoStatus.initial:
                                    case MeetingInfoStatus.loading:
                                      membersCount = const SizedBox(
                                          child: CircularProgressIndicator());
                                      break;
                                    case MeetingInfoStatus.error:
                                      membersCount =
                                          const Icon(Icons.error_outline);
                                      break;
                                    case MeetingInfoStatus.close:
                                      membersCount = const Center();
                                      context.pop();
                                      break;

                                    case MeetingInfoStatus.loaded:
                                      membersCount = Text(
                                        state.members.length.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      );
                                  }
                                  return Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.people_outline,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '참여인원 ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                              membersCount,
                                              Text(
                                                '/${meeting.maxMembers}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: joinButton(context, meeting, state.members)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Builder joinButton(BuildContext context, Meeting meeting, List<Member> members) {
    return Builder(builder: (_) {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final isHost = meeting.hostUid == currentUid;
      final isJoin = members.any((Member member) => member.uid == currentUid);
      final isFull = members.length >= meeting.maxMembers;

      if (isHost) {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, color: Colors.blue),
            SizedBox(width: 5),
            Text(
              '내 모임',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        );
      } else if (isJoin) {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined),
            SizedBox(width: 5),
            Text(
              '참여중',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        );
      } else if (isFull) {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off_outlined),
            SizedBox(width: 5),
            Text(
              '인원초과',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        );
      } else {
        return BlocProvider(
          create: (context) => MeetingJoinCubit(
              meetingRepository: context.read<MeetingRepository>()),
          child: BlocBuilder<MeetingJoinCubit, MeetingJoinState>(
            builder: (context, state) {
              switch (state.status) {
                case MeetingJoinStatus.initial:
                  return joinTextButton(
                    () =>
                        context.read<MeetingJoinCubit>().joinMeeting(meetingId),
                    const Text(
                      '참여하기',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                case MeetingJoinStatus.loading:
                  return joinTextButton(
                    () => (),
                    const CircularProgressIndicator(),
                  );
                case MeetingJoinStatus.failure:
                case MeetingJoinStatus.error:
                case MeetingJoinStatus.success:
                  return joinTextButton(
                    () => (),
                    const Text(
                      '에러',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
              }
            },
          ),
        );
      }
    });
  }

  TextButton joinTextButton(VoidCallback onPressed, Widget widget) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_add_outlined),
          const SizedBox(width: 5),
          widget,
        ],
      ),
    );
  }
}

class RowMeetingInfo extends StatelessWidget {
  const RowMeetingInfo({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
