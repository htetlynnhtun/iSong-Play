import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnectionBloc {
  late final StreamSubscription<InternetConnectionStatus> listener;

  NetworkConnectionBloc() {
    listener = InternetConnectionChecker.createInstance(
      checkInterval: const Duration(seconds: 1),
      // checkTimeout: const Duration(seconds: 1),
    ).onStatusChange.listen((event) {
      switch (event) {
        case InternetConnectionStatus.connected:
          status.value = ConnectionStatus.connected;
          break;
        case InternetConnectionStatus.disconnected:
          status.value = ConnectionStatus.disconnected;
          break;
      }
    });
  }

  // ========================= States =========================
  final status = ValueNotifier<ConnectionStatus>(ConnectionStatus.disconnected);

  Future<bool> hasConnection() {
    return InternetConnectionChecker().hasConnection;
  }

  void dispose() {
    listener.cancel();
    status.dispose();
  }
}

enum ConnectionStatus { connected, disconnected }
