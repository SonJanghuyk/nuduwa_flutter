import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
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

    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AuthenticationChanged(user)),
    );

    debugPrint('AuthenticationBloc시작');
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


  @override
  Future<void> close() {
    debugPrint('AuthenticationBloc끝');
    _userSubscription.cancel();
    return super.close();
  }
}
