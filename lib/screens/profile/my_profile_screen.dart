import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuduwa_flutter/screens/nuduwa_app/bloc/authentication_bloc.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('MyProfileScreen'),
          TextButton(
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationSignedOut()),
            child: const Text('로그아웃하기'),
          ),
        ],
      ),
    );
  }
}
