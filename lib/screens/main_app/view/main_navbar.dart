import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/components/utils/map_helper.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/repository/user_meeting_repository.dart';
import 'package:nuduwa_flutter/screens/main_app/bloc/authentication_bloc.dart';
import 'package:nuduwa_flutter/components/nuduwa_colors.dart';
import 'package:nuduwa_flutter/route/app_route.dart';
import 'package:nuduwa_flutter/screens/main_app/bloc/user_meeting_bloc.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/bloc/map_bloc.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/bloc/meeting_of_map_bloc.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          context.goNamed(RouteNames.login);
        }
      },
      child: Scaffold(
        body: RepositoryProvider(
          create: (_) => MeetingRepository(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UserMeetingBloc(
                    userMeetingRepository: UserMeetingRepository()),
              ),
              
              // ----- MapScreen Bloc ------
              BlocProvider(
                create: (context) => MeetingOfMapBloc(
                  meetingRepository: context.read<MeetingRepository>(),
                ),
              ),
              BlocProvider(
                create: (context) => MapBloc(
                  mapHelper: MapHelper(
                    drawIconOfMeeting: DrawIconOfMeeting(
                      imageSize: !kIsWeb ? 80.0 : 26.666,
                      borderWidth: !kIsWeb ? 10.0 : 3.333,
                      triangleSize: !kIsWeb ? 30.0 : 10.0,
                    ),
                  ),
                ),
              ),
            ],
            child: navigationShell,
          ),
        ),
        bottomNavigationBar: _navigationBar(context),
      ),
    );
  }

  NavigationBar _navigationBar(BuildContext context) {
    return NavigationBar(
      height: 60,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.map),
          label: '찾기',
          selectedIcon: Icon(Icons.map, color: NuduwaColors.navSelect),
        ),
        NavigationDestination(
          icon: Icon(Icons.people),
          label: '모임',
          selectedIcon: Icon(Icons.people, color: NuduwaColors.navSelect),
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble),
          label: '1:1 채팅',
          selectedIcon: Icon(Icons.chat_bubble, color: NuduwaColors.navSelect),
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: '내 정보',
          selectedIcon: Icon(Icons.person, color: NuduwaColors.navSelect),
        ),
      ],
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (int index) => _onTap(context, index),
      indicatorColor: NuduwaColors.navIndicato,
      surfaceTintColor: NuduwaColors.navBackground,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
