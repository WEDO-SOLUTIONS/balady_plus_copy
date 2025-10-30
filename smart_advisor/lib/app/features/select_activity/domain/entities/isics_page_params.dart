import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';

class IsicsPageParams {
  LookUpItem rubric;
  LookUpItem category;
  LookUpItem sector;

  IsicsPageParams(
      {required this.rubric, required this.category, required this.sector});
}
