import 'package:share_plus/share_plus.dart';

class ShareUtil {
  static void share(String? objectId) => Share.share('https://plus.balady.sa/#/poi-map?dgis-object-id=$objectId');
}
