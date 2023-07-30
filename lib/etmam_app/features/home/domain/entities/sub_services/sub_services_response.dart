import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show SubServiceItems;

class SubServiceResponse {
  SubServiceResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  int? totalPageCount;
  int? totalItemCount;
  List<SubServiceItems>? items;
}
