import 'package:balady_plus/app/features/vd/vd_exports.dart' show CategoryItem;

class CameraParamsPage {
  CategoryItem? selectedCategory;
  bool isFromHome;

  CameraParamsPage({this.selectedCategory, this.isFromHome = false});
}
