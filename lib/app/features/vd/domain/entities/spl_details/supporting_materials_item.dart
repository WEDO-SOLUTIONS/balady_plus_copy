import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/constants/apis/env_types.dart';

class SupportingMaterialsItem {
  String? auxillaryMaterialType;
  String? dmsUri;

  SupportingMaterialsItem({this.auxillaryMaterialType, this.dmsUri});

  String? getImageUrl() {
    return "${sl<EnvType>().domain}v1/dms-mobile/files/$dmsUri";
  }
}
