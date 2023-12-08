import 'package:balady_plus/app/features/self_ratiing/data/models/self_rating_item.dart';

class RatingSelfSuccessResult {
  int totalViolation;
  String percentage;

  List<SelfRatingItem> complianes;
  RatingSelfSuccessResult(
      {required this.totalViolation,
      required this.percentage,
      required this.complianes});
}
