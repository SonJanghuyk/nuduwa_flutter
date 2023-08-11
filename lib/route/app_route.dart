import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/screens/chat/chat_room_screen.dart';
import 'package:nuduwa_flutter/screens/chat/chat_screen.dart';
import 'package:nuduwa_flutter/screens/login/login_screen.dart';
import 'package:nuduwa_flutter/screens/main_navbar.dart';
import 'package:nuduwa_flutter/screens/map/map_screen.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_chat_room_screen.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_detail_screen.dart';
import 'package:nuduwa_flutter/screens/meeting/meeting_screen.dart';
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
    routes: [
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
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
                builder: (BuildContext context, GoRouterState state) {
                  return const MeetingScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'detail/:meetingId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: MeetingDetailScreen(
                          meetingId:
                              state.pathParameters['meetingId'] as String,
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
                    path: 'chatroom',
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
                builder: (BuildContext context, GoRouterState state) {
                  return ChatScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'room',
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
                builder: (BuildContext context, GoRouterState state) {
                  return MyProfileScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
