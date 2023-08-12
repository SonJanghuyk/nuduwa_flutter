import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuduwa_flutter/Repository/authentication_repository.dart';
import 'package:nuduwa_flutter/app/nuduwa_app/bloc/authentication_bloc.dart';
import 'package:nuduwa_flutter/components/nuduwa_themes.dart';
import 'package:nuduwa_flutter/route/app_route.dart';

class NuduwaApp extends StatelessWidget {
  const NuduwaApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
        ),
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
