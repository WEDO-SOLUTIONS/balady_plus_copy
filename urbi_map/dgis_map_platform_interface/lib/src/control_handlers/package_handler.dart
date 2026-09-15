import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Turns the native map's offline package notifications into Dart streams:
/// download progress, and changes to a package's metadata.
class PackageEventHandler {
  /// Download progress for every offline package being fetched.
  Stream<PackageProgressEvent> get packageProgressEvents => _packageProgressController.stream;

  final _packageProgressController = StreamController<PackageProgressEvent>.broadcast();

  /// Every change to an offline package's metadata.
  Stream<PackageInfoChangedEvent> get packagesInfoChangedEvents => _packageInfoChangedController.stream;

  final _packageInfoChangedController = StreamController<PackageInfoChangedEvent>.broadcast();

  /// Decodes a progress payload off the platform channel and publishes it on
  /// [packageProgressEvents].
  void packageProgressEvent(Map<dynamic, dynamic> map) {
    final event = PackageProgressEvent(map['packageId'], map['progress']);

    _packageProgressController.sink.add(event);
  }

  /// Maps the status name the native side sends onto a status message.
  PackageUpdateStatusMessage mapStatus(String status) {
    switch (status) {
      case "inProgress":
        return PackageUpdateStatusMessage.inProgress;
      case "notAvailable":
        return PackageUpdateStatusMessage.notAvailable;
      case "paused":
        return PackageUpdateStatusMessage.paused;
      default:
        throw ArgumentError("Invalid mapStatus");
    }
  }

  /// Reads a package's metadata out of its channel payload.
  PackageInfoMessage mapInfo(Map<dynamic, dynamic> map) {
    return PackageInfoMessage(
      name: map["name"],
      installed: map["installed"],
      incomplete: map["incomplete"],
      preinstalled: map["preinstalled"],
      compatible: map["compatible"],
      hasUpdate: map["hasUpdate"],
      updateStatus: mapStatus(map["updateStatus"]),
    );
  }

  /// Decodes a metadata payload off the platform channel and publishes it on
  /// [packagesInfoChangedEvents].
  void packageInfoChangedEvent(Map<dynamic, dynamic> map) {
    _packageInfoChangedController.sink.add(PackageInfoChangedEvent(map["id"], mapInfo(map["info"])));
  }

  /// Closes the package progress and info streams.
  Future<void> dispose() async {
    await _packageProgressController.close();
    await _packageInfoChangedController.close();
  }
}
