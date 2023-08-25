import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuduwa_flutter/repository/authentication_repository.dart';
import 'package:nuduwa_flutter/screens/main_app/bloc/authentication_bloc.dart';
import 'package:nuduwa_flutter/screens/main_app/cubit/location_permission_cubit.dart';
import 'package:nuduwa_flutter/components/nuduwa_themes.dart';
import 'package:nuduwa_flutter/route/app_route.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
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
