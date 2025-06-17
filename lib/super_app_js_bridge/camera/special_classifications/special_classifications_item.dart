import '../../../app/core/dependency_injection/injection_container.dart';
import '../../../app/core/utils/constants/apis/env_types.dart';

class SplItem {
  String? id;
  String? image;
  String? name;
  String? categoryId;

  SplItem({this.categoryId, this.id, this.image, this.name});

  String? getImageUrl() {
    return "${sl<EnvType>().domain}v1/dms-mobile/files/$image";
  }
}
