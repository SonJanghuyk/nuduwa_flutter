import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/components/widgets/nuduwa_appbar.dart';
import 'package:nuduwa_flutter/models/user_meeting.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/route/app_route.dart';
import 'package:nuduwa_flutter/screens/main_app/bloc/user_meeting_bloc.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_card.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_list/bloc/meeting_bloc.dart';

class MeetingList extends StatelessWidget {
  const MeetingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NuduwaAppBar(),
      body: BlocBuilder<UserMeetingBloc, UserMeetingState>(
        builder: (context, state) {
          if (state.status != UserMeetingStatus.stream) {
            context.read<UserMeetingBloc>().add(UserMeetingResumed());
          }
          return ListView.separated(
            itemCount: state.userMeetings.length,
            itemBuilder: (context, index) {
              final bloc = MeetingBloc(
                  meetingRepository: context.read<MeetingRepository>(),
                  userMeeting: state.userMeetings[index],
                );
              return BlocProvider.value(
                value: bloc,
                child: MeetingCard(
                  onTap: () => context.pushNamed(
                    RouteNames.meetingDetail,
                    extra: bloc,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: 0, child: Divider()),
          );
        },
      ),
    );
  }
}
