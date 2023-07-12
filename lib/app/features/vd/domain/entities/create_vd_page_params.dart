import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show AttachmentItem, CategoryItem, SplResponse, GISParams, GISResponse;

class CreateVDParamsPage {
  List<AttachmentItem>? files;
  CategoryItem? selectedCategory;
  SplResponse? splResponse;
  GISParams? location;
  GISResponse? gisResponse;

  bool isFromHome;

  CreateVDParamsPage(
      {this.files,
      this.selectedCategory,
      this.splResponse,
      this.gisResponse,
      this.location,
      this.isFromHome = false});
}
