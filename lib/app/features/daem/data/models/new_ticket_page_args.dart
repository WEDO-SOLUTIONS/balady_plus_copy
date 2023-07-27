import 'daem_item.dart';

class NewTicketPageArgs {
  final DaemItem category;
  final DaemItem? subCategory;
  final DaemItem? area;
  final DaemItem? issueType;

  List<DaemItem> municipalities;
  final List<DaemItem> subCategoryTypeList;
  final List<DaemItem>? areaList;
  final List<DaemItem>? issuesList;
  NewTicketPageArgs(
      {required this.category,
      required this.subCategoryTypeList,
      required this.municipalities,
      this.areaList,
      this.issuesList,
      this.area,
      this.issueType,
      this.subCategory});
}
