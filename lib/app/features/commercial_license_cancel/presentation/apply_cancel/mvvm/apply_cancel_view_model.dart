import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';

class ApplyCancelViewModel extends BaseViewModel {
  final WebService webService;
  final int licenseId;
  final SubmitterInfo submitterInfo;
  final ReasonCancel reasonCancel;

  ApplyCancelViewModel({
    required this.webService,
    required this.licenseId,
    required this.reasonCancel,
    required this.submitterInfo,
  });

  Future<CancellationRequestResponse?>
      applyCommercialLicenseCancellation() async {
    isLoading = true;
    notifyListeners();
    try {
      var response = await webService.dio.post(
        ApiUrl.commercialLicenseApplyCancel(licenseId),
        data: {
          "submitterType": submitterInfo.submitterType,
          "crNumber": submitterInfo.crNumber,
        },
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      isLoading = false;
      notifyListeners();
      return CancellationRequestResponse.fromJson(result);
    } catch (e) {
      showError(e.toString());
    }
    isLoading = false;
    notifyListeners();
    return null;
  }
}

Map<String, dynamic> data = {
  "requestId": 4517277248,
  "cancellationReasons": [
    {"id": 401, "name": "عدم رغبة المستفيد في إكمال العمل التجاري"},
    {"id": 402, "name": "كثرة المخالفات والغرامات"},
    {"id": 403, "name": "تغيير موقع المحل"},
    {"id": 404, "name": "عدم وضوح الإشتراطات وعدم المعرفة بالتحديثات عليها"},
    {"id": 405, "name": "ارتفاع مبالغ الرسوم على المستثمر"},
    {"id": 406, "name": "صعوبة استيفاء كافة الإشتراطات"},
    {"id": 407, "name": "تغيير نوع النشاط"},
    {"id": 408, "name": "ارتفاع أسعار الإيجار"},
    {"id": 409, "name": "عدم توافق مساحة المحل مع الاشتراطات"},
    {"id": 410, "name": "سوء تعامل المراقبين"},
    {"id": 411, "name": "عدم استيفاء كافة الاشتراطات البلدية"},
    {"id": 412, "name": "أخرى"}
  ],
  "availableCloseDate": false,
  "warningInfo": null
};
