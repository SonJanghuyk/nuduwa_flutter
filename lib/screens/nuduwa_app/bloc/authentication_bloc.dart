import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuduwa_flutter/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState>{
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser != null
              ? AuthenticationState.authenticated(authenticationRepository.currentUser!)
              : const AuthenticationState.unauthenticated(),
        ) {
    on<_AuthenticationChanged>(_onUserChanged);
    on<AuthenticationSignedOut>(_onLogoutRequested);
    on<AuthenticationSignedInWithGoogle>(_onGoogleSignIn);

    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AuthenticationChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(_AuthenticationChanged event, Emitter<AuthenticationState> emit) {
    emit(
      event.user != null
          ? AuthenticationState.authenticated(event.user!)
              : const AuthenticationState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AuthenticationSignedOut event, Emitter<AuthenticationState> emit) {
    unawaited(_authenticationRepository.signOut());
  }

  void _onGoogleSignIn(AuthenticationSignedInWithGoogle event,  Emitter<AuthenticationState> emit) async{
    await _authenticationRepository.logInWithGoogle();
  }


  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
