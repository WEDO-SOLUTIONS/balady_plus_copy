import 'package:async/async.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions.g.dart';

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  Future<PermissionStatus> build(Permission permission) async => permission.status;

  final _remember = AsyncMemoizer<PermissionStatus>();

  Future<PermissionStatus> request() async => _remember.runOnce(
        () async {
          try {
            PermissionStatus status = await future;
            if (status.isDenied) {
              status = await permission.request();
            }
            state = AsyncValue.data(status);
            return status;
          } catch (e, stack) {
            state = AsyncValue.error(e, stack);
            rethrow;
          }
        },
      );
}
