import 'package:share_plus/share_plus.dart';

class ShareUtil {
  static void share(String? objectId) => Share.share('https://apps.balady.gov.sa/#/poi-map?dgis-object-id=$objectId');
}
