part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

// final class AuthenticationStarted extends AuthenticationEvent {
//   @override
//   List<Object> get props => [];
// }

final class AuthenticationChanged extends AuthenticationEvent {
  final User? user;
  const AuthenticationChanged(this.user);

  @override
  List<Object?> get props => [user];
}

// final class AuthenticationSignedIn extends AuthenticationEvent {
//   @override
//   List<Object> get props => [];
// }

// final class AuthenticationSignedOut extends AuthenticationEvent {
//       @override
//   List<Object> get props => [];
// }
