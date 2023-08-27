import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'network_connect_state.dart';

class NetworkConnectCubit extends Cubit<NetworkConnectState> {
  NetworkConnectCubit() : super(NetworkConnectInitial()){
    debugPrint('NetworkConnectCubit시작');
  }

  @override
  Future<void> close() {
    debugPrint('NetworkConnectCubit끝');
    return super.close();
  }
}
