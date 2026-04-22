import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityService() {
    _checkInitialConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool online = results.any((result) => result != ConnectivityResult.none);
    
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
    }
  }

  Future<bool> checkConnection() async {
    final results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
    return _isOnline;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
