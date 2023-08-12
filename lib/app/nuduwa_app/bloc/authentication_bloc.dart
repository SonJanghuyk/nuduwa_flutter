import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuduwa_flutter/Repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc({required AuthenticationRepository authenticationRepository})
      : super(
          authenticationRepository.currentUser != null
              ? AuthenticationSuccess(authenticationRepository.currentUser!)
              : AuthenticationFailure(),
        ) {

    on<AuthenticationChanged>((event, emit) {
      emit(
        event.user != null
        ? AuthenticationSuccess(event.user!)
        : AuthenticationFailure(),
      );
    });
  }
}
