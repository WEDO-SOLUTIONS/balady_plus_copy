import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';

class SubmitRatingParams {
  String? orderId;
  String? review;
  List<RatingItem>? items;

  SubmitRatingParams({this.items, this.review, this.orderId});
}
