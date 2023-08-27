import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nuduwa_flutter/repository/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState.initial()) {
    on<LoginWithGoogle>(_googleLogin);
    
    debugPrint('LoginBloc시작');
  }

  final AuthenticationRepository _authenticationRepository;

  void _googleLogin(LoginWithGoogle event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  

  @override
  Future<void> close() {
    debugPrint('LoginBloc끝');
    return super.close();
  }
}
