import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/repository/authentication_repository.dart';
import 'package:nuduwa_flutter/screens/login/bloc/login_bloc.dart';
import 'package:nuduwa_flutter/screens/main_app/bloc/authentication_bloc.dart';
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
      child: BlocProvider(
        create: (context) => LoginBloc(
            authenticationRepository: context.read<AuthenticationRepository>()),
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(40.0),
                      width: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 로고
                          Image.asset(
                            Assets.imageNuduwaLogo,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),

                          const SizedBox(height: 30),

                          // 인삿말1
                          const Text(
                            '너두와에 어서와!',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // 인삿말2
                          const Text(
                            '계속하려면 로그인',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 30,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 버튼들
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 애플로그인 버튼
                        BlocSelector<LoginBloc, LoginState, bool>(
                          selector: (state) =>
                              state.status == LoginStatus.loading,
                          builder: (context, isLoading) {
                            return SnsLoginButton(
                              sns: 'Apple',
                              assetImage: Assets.imageAppleLogo,
                              onPressed: () {},
                              isLoading: isLoading,
                            );
                          },
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          '또는',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 구글로그인 버튼
                        BlocSelector<LoginBloc, LoginState, bool>(
                          selector: (state) =>
                              state.status == LoginStatus.loading,
                          builder: (context, loading) {
                            return SnsLoginButton(
                              sns: 'Google',
                              assetImage: Assets.imageGoogleLogo,
                              onPressed: () => context
                                  .read<LoginBloc>()
                                  .add(LoginWithGoogle()),
                              isLoading: loading,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SnsLoginButton extends StatelessWidget {
  final String sns;
  final String assetImage;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SnsLoginButton({
    super.key,
    required this.sns,
    required this.assetImage,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        fixedSize: const MaterialStatePropertyAll(Size(210, 80)),
        backgroundColor: const MaterialStatePropertyAll(Colors.black),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  assetImage,
                  color: Colors.white,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Text(
                  '$sns 간편로그인',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
}
