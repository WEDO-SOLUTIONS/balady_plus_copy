import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions.g.dart';

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  Future<PermissionStatus> build(Permission permission) async => permission.status;

  Future<PermissionStatus> request() async {
    var status = await future;

    while (status.isDenied) {
      try {
        status = await permission.request();
      } catch (e) {
        // Sometimes permissions asked in parallel which leads to exception
      }
    }

    state = AsyncValue.data(status);
    return status;
  }
}
