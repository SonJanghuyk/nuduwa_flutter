import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/screens/chat/chat_room_screen.dart';
import 'package:nuduwa_flutter/screens/chat/chat_screen.dart';
import 'package:nuduwa_flutter/screens/login/login_screen.dart';
import 'package:nuduwa_flutter/screens/main_app/view/main_navbar.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/map_screen.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_chat_room_screen.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_detail_screen.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_sreen.dart';
import 'package:nuduwa_flutter/screens/profile/my_profile_screen.dart';

class AppRoute {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _sectionNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionNav');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/map',
    debugLogDiagnostics: true,

    errorBuilder: (context, state) => const Text('에러'),
    
    routes: [
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),

      /// Application shell
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return MainNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          //
          // Map Screen
          //
          StatefulShellBranch(
            navigatorKey: _sectionNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/map',
                name: RouteNames.map,
                builder: (BuildContext context, GoRouterState state) {
                  return MapScreen();
                },
              ),
            ],
          ),

          //
          // Meeting Screen
          //
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/meeting',
                name: RouteNames.meeting,
                builder: (BuildContext context, GoRouterState state) {
                  return const MeetingScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'detail/:meetingId',
                    name: RouteNames.meetingDetail,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: MeetingDetailScreen(
                          meetingId: state.pathParameters['meetingId']!,
                        ),
                        transitionDuration: const Duration(milliseconds: 150),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          // Change the opacity of the screen using a Curve based on the the animation's
                          // value
                          return FadeTransition(
                            opacity: CurveTween(curve: Curves.easeInOut)
                                .animate(animation),
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                  GoRoute(
                    path: 'chatroom/:meetingId',
                    name: RouteNames.meetingChatroom,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const MeetingChatRoomScreen();
                    },
                  ),
                ],
              ),
            ],
          ),

          //
          // Chat Screen
          //
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/chat',
                name: RouteNames.chat,
                builder: (BuildContext context, GoRouterState state) {
                  return const ChatScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'room/:otherUid',
                    name: RouteNames.chatRoom,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const ChatRoomScreen();
                    },
                  ),
                ],
              ),
            ],
          ),

          //
          // Profile Screen
          //
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/myprofile',
                name: RouteNames.myprofile,
                builder: (BuildContext context, GoRouterState state) {
                  return const MyProfileScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class RouteNames {
  static const login = 'login';
  static const map = 'map';

  static const meeting = 'meeting';
  static const meetingDetail = 'meetingDetail';
  static const meetingChatroom = 'meetingChatroom';

  static const chat = 'chat';
  static const chatRoom = 'chatRoom';

  static const myprofile = 'myprofile';
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
