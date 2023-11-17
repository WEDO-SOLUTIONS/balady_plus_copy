class PackageConfig {
  static const packageName = 'mapness';

  static const gitBranch =
      String.fromEnvironment('GIT_BRANCH', defaultValue: 'unknown');
  static const gitCommit =
      String.fromEnvironment('GIT_COMMIT', defaultValue: 'unknown');
  static const vendorConfig =
      String.fromEnvironment('VENDOR_CONFIG', defaultValue: 'unknown');
}
