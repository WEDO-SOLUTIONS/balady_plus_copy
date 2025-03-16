import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../data/general_inquiry_data.dart';
import '../../models/classification_response_model.dart';
import '../../services/inquiry_repository.dart';

class InquiryViewModel extends BaseViewModel {
  InquiryViewModel() {}
  final _repositry = InquiryRepository();
  ClassificationResponse? splClassification;
  List<DropDownItem> splClassificationList = [];

  Future<bool> getAllSplClassifications(
      CustomerVoiceReportTypeModel inqTypeModel) {
    showLoading();
    return _repositry
        .getAllSplClassificationsLsit(category: inqTypeModel.code)
        .then((value) {
      hideLoading();
      splClassification = value.item3;
      setSPLClassification(value.item3);

      notifyListeners();
      if (value != null &&
          value.item3 != null &&
          value.item3!.data.isNotEmpty) {
        return true;
      } else {
        showError(value.item2 ?? "");
      }
      return false;
    }).catchError((error) {
      hideLoading();
      String msg = ("server_error_1").tr();

      showError(msg);
      return false;
    });
  }

  void setSPLClassification(ClassificationResponse? data) {
    splClassification = data;
    splClassificationList = data?.data
            .map<DropDownItem>(
                (e) => DropDownItem(id: e.id, name: e.name ?? ""))
            .toList() ??
        [];
  }
}
