import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final InternetConnectionChecker connectionChecker;
  StreamSubscription? _subscription;

  ConnectivityCubit({InternetConnectionChecker? checker})
      : connectionChecker = checker ?? InternetConnectionChecker(),
        super(ConnectivityStatus.online) {
    _subscription = connectionChecker.onStatusChange.listen((status) {
      emit(status == InternetConnectionStatus.connected
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline);
    });
  }

 Future<void> checkConnectivity() async {
  await Future.delayed(Duration(seconds: 2)); 
  final isConnected = await connectionChecker.hasConnection;
  emit(isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline);
}

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}