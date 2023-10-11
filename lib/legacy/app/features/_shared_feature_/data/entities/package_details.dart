import 'package:equatable/equatable.dart' show Equatable;

class PackageDetails extends Equatable {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  const PackageDetails({
    this.appName = "",
    this.packageName = "",
    this.version = "",
    this.buildNumber = "",
  });

  @override
  List<Object?> get props => [appName, packageName, version, buildNumber];

  PackageDetails copyWith({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
  }) {
    return PackageDetails(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }

  @override
  String toString() {
    return 'PackageDetails(appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber)';
  }
}
