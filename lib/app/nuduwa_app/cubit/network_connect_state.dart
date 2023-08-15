part of 'network_connect_cubit.dart';

sealed class NetworkConnectState extends Equatable {
  const NetworkConnectState();

  @override
  List<Object> get props => [];
}

final class NetworkConnectInitial extends NetworkConnectState {}
