import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';

extension BssEntityExt on DirectoryObjectMessage {
  BssEntity? toBss() {
    if (id?.objectId == null) {
      return null;
    }
    return BssEntity(
      id: id!.objectId.toString(),
      type: types.firstOrNull?.type.name ?? 'unknown',
    );
  }
}
