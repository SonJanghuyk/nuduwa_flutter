part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  failure,
  error,
}

final class LoginState extends Equatable {
  const LoginState({
    required this.status,
  });

  final LoginStatus status;

  const LoginState.initial() : this(status: LoginStatus.initial);

  LoginState copyWith({
    LoginStatus? status,
  }) {
    return LoginState(status: status ?? this.status);
  }

   @override
  List<Object?> get props => [status];
}