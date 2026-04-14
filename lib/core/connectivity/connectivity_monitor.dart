import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'connectivity_keys.dart';

/// Widget that listens to real internet availability and shows a persistent
/// "No internet connection" SnackBar until connectivity is restored.
class ConnectivityMonitor extends StatefulWidget {
  final Widget child;
  const ConnectivityMonitor({required this.child, Key? key}) : super(key: key);

  @override
  State<ConnectivityMonitor> createState() => _ConnectivityMonitorState();
}

class _ConnectivityMonitorState extends State<ConnectivityMonitor> {
  late final StreamSubscription<InternetConnectionStatus> _subscription;
  bool _hasSeenOfflineState = false;
  bool _isOfflineSnackBarVisible = false;

  @override
  void initState() {
    super.initState();

    // Listen to real internet status changes
    _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;
      if (!hasConnection) {
        _showNoInternet();
      } else if (_hasSeenOfflineState) {
        _hideNoInternet();
      }
    });

    // Initial check
    InternetConnectionChecker().hasConnection.then((has) {
      if (!has) {
        _showNoInternet();
      }
    });
  }

  void _showNoInternet() {
    _hasSeenOfflineState = true;
    _isOfflineSnackBarVisible = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = rootScaffoldMessengerKey.currentState;
      if (messenger == null) return;
      messenger.removeCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
          duration: Duration(days: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _hideNoInternet() {
    if (!_isOfflineSnackBarVisible) return;
    _isOfflineSnackBarVisible = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = rootScaffoldMessengerKey.currentState;
      if (messenger == null) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Back online', style: TextStyle(color: Colors.white)),  
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
