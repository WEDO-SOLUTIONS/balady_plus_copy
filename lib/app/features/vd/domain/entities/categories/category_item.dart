import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';

import '../../../../../core/dependency_injection/injection_container.dart';

class CategoryItem {
  String? icon;
  String? description;
  String? type;
  String? categoryName;
  String? categoryId;
  String? mainImage;
  bool? isPromoted;

  CategoryItem(
      {this.categoryId,
      this.categoryName,
      this.description,
      this.icon,
      this.isPromoted,
      this.mainImage,
      this.type});

  String? getMainImageUrl() {
    return "${sl<EnvType>().domain}v1/dms-mobile/files/$mainImage";
  }

  String? getIconeUrl() {
    return "${sl<EnvType>().domain}v1/dms-mobile/files/$icon";
  }
}
