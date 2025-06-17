import '../../../../app/core/utils/enums/enums.dart';
import '../../camera_page.dart';

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
