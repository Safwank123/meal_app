import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/core/utiles/app_prompts.dart';


import '../../main.dart';

class NetworkBloc extends Cubit<NetworkState> {
  static final NetworkBloc _instance = NetworkBloc._internal();
  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool _wasDisconnected = false;
  bool _hasShownDisconnectedToast = false;

  factory NetworkBloc({required Connectivity connectivity}) => _instance;

  NetworkBloc._internal({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(NetworkState.connected()) {
    _monitorInternet();
  }

  void _monitorInternet() async {
    final List<ConnectivityResult> initialResult =
        await _connectivity.checkConnectivity();
    _handleConnectivityChange(initialResult);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      _handleDisconnection();
    } else {
      _handleConnection();
    }
  }

  void _handleDisconnection() {
    _wasDisconnected = true;
    emit(NetworkState.disconnected());

    if (!_hasShownDisconnectedToast) {
      AppPrompts.showError(message: "No Internet Connection");
      _hasShownDisconnectedToast = true;
    }
  }

  void _handleConnection() {
    if (_wasDisconnected) {
      emit(NetworkState.restored());
      _wasDisconnected = false;
      _hasShownDisconnectedToast = false;
    } else {
      emit(NetworkState.connected());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }

  // Optional: Reset singleton for testing
  static void reset() {
    _instance._connectivitySubscription.cancel();
    // Recreate the instance
    NetworkBloc._internal();
  }
}

class NetworkState {
  final bool isConnected;
  final bool isRestored;

  NetworkState.connected() : isConnected = true, isRestored = false;

  NetworkState.disconnected() : isConnected = false, isRestored = false;

  NetworkState.restored() : isConnected = true, isRestored = true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkState &&
          runtimeType == other.runtimeType &&
          isConnected == other.isConnected &&
          isRestored == other.isRestored;

  @override
  int get hashCode => isConnected.hashCode ^ isRestored.hashCode;
}

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  NetworkBloc? _networkBloc;

  factory NetworkManager() => _instance;

  NetworkManager._internal();

  void initialize(NetworkBloc networkBloc) => _networkBloc = networkBloc;

  NetworkState get currentState =>
      _networkBloc?.state ?? navigatorKey.currentContext?.read<NetworkBloc>().state ?? NetworkState.connected();

  bool get isConnected => currentState.isConnected;

  bool get isDisconnected => !isConnected;

  Stream<NetworkState> get onNetworkStateChanged => _networkBloc?.stream ?? Stream.value(NetworkState.connected());

  void whenConnected(VoidCallback action, {VoidCallback? onDisconnected}) {
    if (isConnected) {
      action();
    } else {
      onDisconnected?.call();
    }
  }
}