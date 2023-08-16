import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_connect_state.dart';

class NetworkConnectCubit extends Cubit<NetworkConnectState> {
  NetworkConnectCubit() : super(NetworkConnectInitial());
}
