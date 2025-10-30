import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';

enum GenderType {
  male(type: "male", icon: IconPath.maleAvatarIcon),
  female(type: "female", icon: IconPath.femaleAvatarIcon);

  const GenderType({required this.type, required this.icon});
  final String type;
  final String icon;
}
