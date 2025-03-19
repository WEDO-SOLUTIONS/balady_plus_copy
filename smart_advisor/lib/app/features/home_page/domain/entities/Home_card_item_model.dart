import 'package:smart_advisor/app/core/utils/utils_exports.dart';

class HomeCardItemModel {
  final String title;
  final String image;
  final bool isDisabled;

  HomeCardItemModel(
      {required this.title, required this.image, required this.isDisabled});
}

List<HomeCardItemModel> homeCardItems = [
  HomeCardItemModel(
    title: 'الرخص التجارية للمحلات / المنشاَت',
    image: IconPath.commercialBackground,
    isDisabled: false,
  ),
  HomeCardItemModel(
    //  title: 'البناء و الأراضي',
    title: "",
    image: IconPath.constructionsBackground,
    isDisabled: true,
  ),
  HomeCardItemModel(
    //  title: 'الحفريات',
    title: "",
    image: IconPath.drillingBackground,
    isDisabled: true,
  ),

  // HomeCardItemModel(title: 'Item 3', image: 'assets/images/image3.png'),
];
