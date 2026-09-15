import 'package:dgis_map_platform_interface/library.dart';

/// Reports how far along the download of an offline map package is.
class PackageProgressEvent {
  /// Creates the event for package [id] at [progress] per cent.
  PackageProgressEvent(this.id, this.progress);

  /// Identifier of the package being downloaded.
  final String id;

  /// Percentage downloaded so far, 0 to 100.
  final int progress;

  /// Name of the platform channel event this is decoded from.
  static const name = "packageProgressEvent";
}

/// Reports that an offline map package's metadata changed - for instance it
/// finished installing, or a newer version became available.
class PackageInfoChangedEvent {
  /// Creates the event for package [id] with its new [packageInfo].
  PackageInfoChangedEvent(this.id, this.packageInfo);

  /// Identifier of the package that changed.
  final String id;

  /// The package's current metadata.
  final PackageInfoMessage packageInfo;

  /// Name of the platform channel event this is decoded from.
  static const name = "packageInfoChangedEvent";
}
