import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info.g.dart';

@Riverpod(keepAlive: true)
class _PackageInfo extends _$PackageInfo {
  @override
  Future<PackageInfo> build() async {
    return PackageInfo.fromPlatform();
  }
}

final packageInfoProvider = _packageInfoProvider;
