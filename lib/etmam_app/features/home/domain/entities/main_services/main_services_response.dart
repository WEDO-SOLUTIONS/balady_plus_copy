import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show MainServiceItems;

class MainServiceResponse {
  MainServiceResponse({this.totalPageCount, this.totalItemCount, this.items});

  int? totalPageCount;
  int? totalItemCount;
  List<MainServiceItems>? items;
}
