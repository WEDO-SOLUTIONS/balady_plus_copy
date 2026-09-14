import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

class PackageEventHandler {
  Stream<PackageProgressEvent> get packageProgressEvents => _packageProgressController.stream;

  final _packageProgressController = StreamController<PackageProgressEvent>.broadcast();

  Stream<PackageInfoChangedEvent> get packagesInfoChangedEvents => _packageInfoChangedController.stream;

  final _packageInfoChangedController = StreamController<PackageInfoChangedEvent>.broadcast();

  void packageProgressEvent(Map<dynamic, dynamic> map) {
    final event = PackageProgressEvent(map['packageId'], map['progress']);

    _packageProgressController.sink.add(event);
  }

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

  void packageInfoChangedEvent(Map<dynamic, dynamic> map) {
    _packageInfoChangedController.sink.add(PackageInfoChangedEvent(map["id"], mapInfo(map["info"])));
  }

  /// Closes the package progress and info streams.
  Future<void> dispose() async {
    await _packageProgressController.close();
    await _packageInfoChangedController.close();
  }
}
