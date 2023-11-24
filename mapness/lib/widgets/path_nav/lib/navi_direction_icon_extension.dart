import 'package:dgis_map/library.dart';

extension NaviDirectionIconExtensionon on NaviCameraDirection {
  String get iconPath {
    switch (this) {
      case NaviCameraDirection.along:
        return "packages/dgis_map/assets/svg/dgis_navi_ic_camera_along.svg";
      case NaviCameraDirection.against:
        return "packages/dgis_map/assets/svg/dgis_navi_ic_camera_against.svg";
      case NaviCameraDirection.both:
        return "packages/dgis_map/assets/svg/dgis_navi_ic_camera_both.svg";
    }
  }
}
