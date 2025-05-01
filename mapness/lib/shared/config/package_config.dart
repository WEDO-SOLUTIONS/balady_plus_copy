class PackageConfig {
  static const gitBranch = String.fromEnvironment('GIT_BRANCH', defaultValue: 'unknown');
  static const gitCommit = String.fromEnvironment('GIT_COMMIT', defaultValue: 'unknown');
  static const vendorConfig = String.fromEnvironment('VENDOR_CONFIG', defaultValue: 'unknown');
  static const buildName = String.fromEnvironment('CI_BUILD_NAME', defaultValue: 'unknown');
  static const releaseVersion = String.fromEnvironment('CI_RELEASE_VERSION', defaultValue: 'unknown');
}
