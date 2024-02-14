import 'package:balady_plus/app/features/calculator/data/model/response/CalculateCostResponse.dart';
import 'package:balady_plus/app/features/calculator/data/model/response/CalculateCostV03Response.dart';
import 'package:balady_plus/app/features/calculator/data/model/response/CalculateDiggingResponse.dart';

class CalculatorResultsPageParams {
  CalculateCostV03Response? calculateCostV03Response;
  CalculateCostResponse? calculateCostResponse;
  CalculateDiggingResponse? calculateDiggingResponse;
  bool? hideNote;

  CalculatorResultsPageParams(
      {this.calculateCostResponse,
      this.calculateCostV03Response,
      this.calculateDiggingResponse,
      this.hideNote});
}
