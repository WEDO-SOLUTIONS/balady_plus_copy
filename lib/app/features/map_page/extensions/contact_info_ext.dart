import 'package:dgis_map/library.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

extension ContactPhone on List<ContactInfoMessage?> {
  String? phoneNumber() {
    return firstWhereOrNull((element) {
      debugPrint("element?.type ${element?.displayText}");
      return element?.type == "phone";
    })?.displayText;
  }
}
