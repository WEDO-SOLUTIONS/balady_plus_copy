import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show AttachmentItem, CategoryItem, SplResponse, GISParams, GISResponse;

import '../../../../core/utils/enums/enums.dart';

class CreateVDParamsPage {
  List<AttachmentItem>? files;
  CategoryItem? selectedCategory;
  SplResponse? splResponse;
  GISParams? location;
  GISResponse? gisResponse;

  bool isFromHome;
  bool qrCodeFlow;
  PAGE_TYPE? pageType;

  CreateVDParamsPage(
      {this.files,
      this.selectedCategory,
      this.splResponse,
      this.gisResponse,
      this.location,
      this.isFromHome = false,
      this.qrCodeFlow = false,
      this.pageType});
}
