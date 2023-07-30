import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchItem;

class SearchItemModel extends SearchItem {
  SearchItemModel({super.id, super.name, super.logoImageUrl});

  factory SearchItemModel.fromMap(Map<String, dynamic> json) => SearchItemModel(
        id: json["id"],
        name: json["name"],
        logoImageUrl: json["logoImageUrl"],
      );
}
