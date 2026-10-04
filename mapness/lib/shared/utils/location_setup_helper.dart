import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSetupHelper with WidgetsBindingObserver {
  LocationSetupHelper(this.controller);

  final DgisMapController controller;

  final _log = (String m) => logger.log('🛰️ [LOCATION] $m');

  bool _requestInProgress = false;

  Future<void> run() async {
    WidgetsBinding.instance.addObserver(this);
    try {
      await _tryActivate();
      // wait until activate() says "done"
    } catch (e) {
      _log('$e');
    }
  }

  /// Detach from the widgets binding. Must be called when the owning
  /// provider is disposed, otherwise each rebuild leaks a live observer
  /// bound to a stale controller reference.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _tryActivate() async {
    // don't access PermissionManager concurrently
    if (_requestInProgress) {
      return;
    }

    PermissionStatus status = await Permission.location.status;
    _log('current status: $status'); // current status

    // if not yet granted – request
    if (!status.isGranted) {
      // if not yet granted – request
      _requestInProgress = true;
      try {
        status = await Permission.location.request();
      } on PlatformException catch (_) {
        // another request already running – just exit and wait for RESUMED
        _log(
          'another request already running → waiting',
        ); // another request already running – just exit and wait for RESUMED
        return;
      } finally {
        _requestInProgress = false;
      }
    }

    if (status.isGranted) {
      await _activateLocation();
    }
  }

  Future<void> _activateLocation() async {
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }

    _log('permission granted → enabling location services');
    await controller.onLocationPermissionGranted(desiredAccuracy: DesiredAccuracyMessage.high);
  }
}
