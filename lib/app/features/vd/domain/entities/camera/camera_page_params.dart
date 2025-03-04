import 'package:balady_plus/app/features/vd/vd_exports.dart' show CategoryItem;

import '../../../../../core/utils/enums/enums.dart';

class CameraParamsPage {
  CategoryItem? selectedCategory;

  // bool isFromHome;
  String? address;
  double? lat;
  double? lon;
  bool qrCodeFlow;
  PAGE_TYPE? pageType;

  CameraParamsPage({
    this.selectedCategory,
    this.address,
    this.lat,
    this.lon,
    // this.isFromHome = false,
    this.qrCodeFlow = false,
    this.pageType,
  });
}
