import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuduwa_flutter/repository/authentication_repository.dart';
import 'package:nuduwa_flutter/repository/user_meeting_repository.dart';
import 'package:nuduwa_flutter/screens/nuduwa_app/bloc/authentication_bloc.dart';
import 'package:nuduwa_flutter/screens/nuduwa_app/bloc/user_meeting_bloc.dart';
import 'package:nuduwa_flutter/screens/nuduwa_app/cubit/location_permission_cubit.dart';
import 'package:nuduwa_flutter/components/nuduwa_themes.dart';
import 'package:nuduwa_flutter/route/app_route.dart';

class NuduwaApp extends StatelessWidget {
  const NuduwaApp({
    required AuthenticationRepository authenticationRepository,
    required UserMeetingRepository userMeetingRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _userMeetingRepository = userMeetingRepository;

  final AuthenticationRepository _authenticationRepository;
  final UserMeetingRepository _userMeetingRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(value: _userMeetingRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            lazy: false,
            create: (_) => AuthenticationBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider<LocationPermissionCubit>(
            lazy: false,
            create: (_) => LocationPermissionCubit(),
          ),
          BlocProvider<UserMeetingBloc>(
            create: (_) => UserMeetingBloc(
              userMeetingRepository: _userMeetingRepository,
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'NUDUWA',
          theme: NuduwaThemes.lightTheme,
          routerConfig: AppRoute.router,
        ),
      ),
    );
  }
}
