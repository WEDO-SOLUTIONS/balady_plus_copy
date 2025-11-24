import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'directory_object_from_dgis_id.g.dart';

@riverpod
Future<DirectoryObjectMessage?> directoryObjectFromDgisId(
  DirectoryObjectFromDgisIdRef ref,
  DgisObjectId objectId,
) async {
  final dgisController = ref.watch(dgisControllerProvider);
  final result = await dgisController.value?.searchByObjectId(objectId.toMessage());
  return result;
}
