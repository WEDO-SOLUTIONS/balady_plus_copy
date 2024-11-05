import 'package:smart_advisor/app/core/utils/utils_exports.dart';

class HomeCardItemModel {
  final String title;
  final String image;

  HomeCardItemModel({required this.title, required this.image});
}

List<HomeCardItemModel> homeCardItems = [
  HomeCardItemModel(
      title: 'الرخص التجارية للمحلات / المنشاَت',
      image: IconPath.commercialBackground),
  HomeCardItemModel(
      title: 'البناء و الأراضي', image: IconPath.constructionsBackground),
  // HomeCardItemModel(title: 'Item 3', image: 'assets/images/image3.png'),
];
