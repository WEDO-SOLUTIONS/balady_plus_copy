import 'package:dgis_map_platform_interface/library.dart';

class PackageProgressEvent {
  PackageProgressEvent(this.id, this.progress);

  final String id;
  final int progress;

  static const name = "packageProgressEvent";
}

class PackageInfoChangedEvent {
  PackageInfoChangedEvent(this.id, this.packageInfo);

  final String id;
  final PackageInfoMessage packageInfo;

  static const name = "packageInfoChangedEvent";
}
