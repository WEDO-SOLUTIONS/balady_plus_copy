import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class ShareUtil {
static void share(String? objectId, {required BuildContext context}) =>
      safeShareText(
        'https://plus.balady.sa/#/poi-map?dgis-object-id=$objectId',
        context: context,
      );
}
