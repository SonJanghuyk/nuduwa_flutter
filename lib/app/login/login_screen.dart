import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nuduwa_flutter/app/nuduwa_app/bloc/authentication_bloc.dart';
import 'package:nuduwa_flutter/route/app_route.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.goNamed(RouteNames.map);
        }
      },
      child: Scaffold(
        body: Center(
          child: TextButton(
            child: Text('로그인'),
            onPressed: () async {
              final GoogleSignInAccount? googleUser =
                  await GoogleSignIn().signIn();
              final GoogleSignInAuthentication? googleAuth =
                  await googleUser?.authentication;

              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken,
              );
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
          ),
        ),
      ),
    );
  }
}
