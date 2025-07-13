import 'package:dgis_map/library.dart';
import 'package:collection/collection.dart';

extension ContactPhone on List<ContactInfoMessage?> {
  String? phoneNumber() {
    return firstWhereOrNull((element) {
      print("element?.type ${element?.displayText}");
      return element?.type == "phone";
    })?.displayText;
  }
}
