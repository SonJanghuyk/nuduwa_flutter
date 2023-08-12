part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

// final class AuthenticationInitial extends AuthenticationState {
//   @override
//   List<Object?> get props => [];
// }

final class AuthenticationSuccess extends AuthenticationState {
  final User user;
  const AuthenticationSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthenticationFailure extends AuthenticationState {
  @override
  List<Object> get props => [];
}
