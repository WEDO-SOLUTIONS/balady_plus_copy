import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSetupHelper with WidgetsBindingObserver {
  LocationSetupHelper(this.controller);

  final DgisMapController controller;

  final _log = (String m) => debugPrint('🛰️ [LOCATION] $m');

  final _completer = Completer<void>();
  bool _requestInProgress = false;

  Future<void> run() async {
    WidgetsBinding.instance.addObserver(this);
    try {
      await _tryActivate();
      // wait until activate() says "done"
      await _completer.future;
    } finally {
      WidgetsBinding.instance.removeObserver(this);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_completer.isCompleted) {
      _log('app RESUMED → checking status again');
      // dialog closed → can recheck
      _tryActivate();
    }
  }

  Future<void> _tryActivate() async {
    // don't access PermissionManager concurrently
    if (_requestInProgress) return; // don't access PermissionManager concurrently

    var status = await Permission.location.status;
    _log('current status: $status'); // current status

    // if not yet granted – request
    if (!status.isGranted) { // if not yet granted – request
      _requestInProgress = true;
      try {
        status = await Permission.location.request();
      } on PlatformException catch (e) {
        // another request already running – just exit and wait for RESUMED
        _log('another request already running → waiting'); // another request already running – just exit and wait for RESUMED
        return;
      } finally {
        _requestInProgress = false;
      }
    }

    if (status.isGranted) {
      await _activateLocation();
      if (!_completer.isCompleted) _completer.complete();
    }
  }

  Future<void> _activateLocation() async {
    _log('permission granted → enabling follow-location'); // permission granted → enabling follow-location
    await controller.onLocationPermissionGranted(
      desiredAccuracy: DesiredAccuracyMessage.high,
    );
    await controller.toggleFollowState();
  }
}