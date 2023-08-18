part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

final class _AuthenticationChanged extends AuthenticationEvent {  
  const _AuthenticationChanged(this.user);
  final User? user;

  @override
  List<Object?> get props => [user];
}

final class AuthenticationSignedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

final class AuthenticationSignedInWithGoogle extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}